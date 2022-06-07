Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7356E540177
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 16:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244467AbiFGOdd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 10:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243354AbiFGOda (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 10:33:30 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04CC2B36F4;
        Tue,  7 Jun 2022 07:33:29 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 257EW6VH011786;
        Tue, 7 Jun 2022 14:33:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=2Fl+E7n61EDWOdDB4Qwnb/kTFDcxq7ECEIrMTRqG8XY=;
 b=sJN7DibwXj+7XrXFRHe6M2Q/Z28jOZ/4C3e/oG0GNig79P1RfPG6BJLhldUvIxWlU+nr
 /Zy8KMKzl67zaFMrmNqmakR0YXoZwywpJVAYm6weuc6XaesFCgJ574vT8IjErkpuVPjk
 2TLAJ0bdlRMvDNVYwEB+cWMqSbcDMpiyOgOJeZLssEtUqa4Er3s9xXYMqYUMjdLn5jfp
 yey8lqoniUPob52A+LBBT2iOHSux3qiEflmDN9V7wvhA5DW0Q7+fhkG7kWA2h7dDEO/1
 rrlnoK6XD3vgC1H+zypXQYxR+f30DmUHrns2nBvc8T4r2KGe911VdOz64nqDECFg8grW Uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gj7w4s2xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jun 2022 14:33:29 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 257EXSXu016064;
        Tue, 7 Jun 2022 14:33:28 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gj7w4s2wp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jun 2022 14:33:28 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 257EM5Oj027264;
        Tue, 7 Jun 2022 14:33:26 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3gfxnhux88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jun 2022 14:33:26 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 257EXNG113304116
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Jun 2022 14:33:23 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04BFCA405B;
        Tue,  7 Jun 2022 14:33:23 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75D37A405F;
        Tue,  7 Jun 2022 14:33:22 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1 (unknown [9.171.69.129])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue,  7 Jun 2022 14:33:22 +0000 (GMT)
Date:   Tue, 7 Jun 2022 16:33:20 +0200
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        scgl@linux.ibm.com, mimu@linux.ibm.com
Subject: Re: [PATCH v11 18/19] KVM: s390: pv: avoid export before import if
 possible
Message-ID: <20220607163320.2b1d966a@li-ca45c2cc-336f-11b2-a85c-c6e71de567f1>
In-Reply-To: <20220603065645.10019-19-imbrenda@linux.ibm.com>
References: <20220603065645.10019-1-imbrenda@linux.ibm.com>
        <20220603065645.10019-19-imbrenda@linux.ibm.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dIxryWdMW6ZEHAF3_oCd8kaZcK-bbeHW
X-Proofpoint-GUID: U1AhcWVbAhWctiHHyPKNUB3ZXgTvknfb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-07_06,2022-06-07_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 clxscore=1015 adultscore=0 spamscore=0 mlxlogscore=820
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206070058
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  3 Jun 2022 08:56:44 +0200
Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:

> If the appropriate UV feature bit is set, there is no need to perform
> an export before import.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
