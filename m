Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 722E6542FE8
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 14:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238578AbiFHMHE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 08:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiFHMHD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 08:07:03 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C797396BF;
        Wed,  8 Jun 2022 05:07:01 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 258BqYoq009177;
        Wed, 8 Jun 2022 12:07:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=cXixKaaJgDBnxATXfFN84OGHzoON5mCeI0Ro/+g//u4=;
 b=h6netybUnQruQ/QOgul3xwGiQ8i4bIcoNibqOOBSXUqMsS4sVjYlPt/EpIoxR9c9dOl6
 8MllQkyjr1Xi7JAU/uasAWIokZ57bv9m20+t9DaPbkLxjVulCn+0HpCMQ2wbrK9M+kNu
 HAM2/u1vqANO5sddfq02ME8tMq9yf+HBsY5N7XVfP+FA1oDZjrQDbXuzO1kM6bqwRZd8
 csXcWL5b/MCfLUHAOG2oJkgDqobiqvyuX6xnhv3U1Ceov4YxRSGYE5WLq9u2olKaQOBb
 AzYXvF0EefSh6iqOlDGzJfT0fIEkM0ksu4T/eOpY2Zrld9n9y+SDPQnMk9qTlHsgBBuy Ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjsxxsyqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 12:07:01 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 258BqZcu009276;
        Wed, 8 Jun 2022 12:07:00 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjsxxsynv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 12:07:00 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 258C6GFe021013;
        Wed, 8 Jun 2022 12:06:58 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3gfxnhw6my-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 12:06:58 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 258C6t1c23920896
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jun 2022 12:06:55 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86F184C040;
        Wed,  8 Jun 2022 12:06:55 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E6434C04A;
        Wed,  8 Jun 2022 12:06:55 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1 (unknown [9.152.224.44])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Jun 2022 12:06:55 +0000 (GMT)
Date:   Wed, 8 Jun 2022 14:06:53 +0200
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        scgl@linux.ibm.com, mimu@linux.ibm.com
Subject: Re: [PATCH v11 13/19] KVM: s390: pv: destroy the configuration
 before its memory
Message-ID: <20220608140653.0afd1e75@li-ca45c2cc-336f-11b2-a85c-c6e71de567f1>
In-Reply-To: <20220603065645.10019-14-imbrenda@linux.ibm.com>
References: <20220603065645.10019-1-imbrenda@linux.ibm.com>
        <20220603065645.10019-14-imbrenda@linux.ibm.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MUia7LRik7XvRU1QOtlTJ40OnplvHaFt
X-Proofpoint-ORIG-GUID: 8And7xx3QvkMCQ87-4Q_-wzYAjJrWrWg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_04,2022-06-07_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 malwarescore=0 adultscore=0 spamscore=0 suspectscore=0 bulkscore=0
 clxscore=1015 mlxscore=0 priorityscore=1501 mlxlogscore=900
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  3 Jun 2022 08:56:39 +0200
Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:

> Move the Destroy Secure Configuration UVC before the loop to destroy
> the memory. If the protected VM has memory, it will be cleaned up and
> made accessible by the Destroy Secure Configuraion UVC. The struct
> page for the relevant pages will still have the protected bit set, so
> the loop is still needed to clean that up.
> 
> Switching the order of those two operations does not change the
> outcome, but it is significantly faster.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
