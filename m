Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C92540004
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 15:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243607AbiFGN3d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 09:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244689AbiFGN3a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 09:29:30 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7729CEAB8A;
        Tue,  7 Jun 2022 06:29:28 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 257DK1rT012856;
        Tue, 7 Jun 2022 13:29:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=dk7xPZFHSfP9GmM6OT0sYILK2ge94OGPpbJ5sMnGW8Q=;
 b=s2W9GeprSx/mA1hYs9jQNJ3LgjJQZEUbnNL8TgAGZqOUNL8KBoeFsuBy1J33aLlfiSLn
 Pf7dc0qM2H9S94U8kLFTMY3jd+B0+x2+VCHwImFqDcP102KhlsZJZwKzomL+eBXzvTL1
 u5csGtxBkioUugnwHdsswH2OytXqMzV7uFc2+ckNOjtMPUmJ4w4jasA+lKnUhlANqdrX
 BXk+oyGHIPmwEx9U3X8VV8TqEyJFmJcQjyvdQzdJQqU0edOOpUX+2tighJpzsOXvPenl
 /mst1WQ6FVbclu2ReGX8XLntjS0D3qSzfWMEIz36tBeN3Q18kp7VqSHlL9UljC6wKoKY EA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gj58kkd3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jun 2022 13:29:27 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 257Clu91019707;
        Tue, 7 Jun 2022 13:29:27 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gj58kkd2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jun 2022 13:29:27 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 257DM3EG010204;
        Tue, 7 Jun 2022 13:29:24 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3gfxnhuuq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jun 2022 13:29:24 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 257DTLqK20513026
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Jun 2022 13:29:21 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D121A4053;
        Tue,  7 Jun 2022 13:29:21 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BB1DA4059;
        Tue,  7 Jun 2022 13:29:21 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1 (unknown [9.171.4.38])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue,  7 Jun 2022 13:29:21 +0000 (GMT)
Date:   Tue, 7 Jun 2022 15:29:19 +0200
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, scgl@linux.ibm.com, pmorel@linux.ibm.com,
        thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 1/2] s390x: skey.c: rework the
 interrupt handler
Message-ID: <20220607152919.1bf0bc3a@li-ca45c2cc-336f-11b2-a85c-c6e71de567f1>
In-Reply-To: <20220603154037.103733-2-imbrenda@linux.ibm.com>
References: <20220603154037.103733-1-imbrenda@linux.ibm.com>
        <20220603154037.103733-2-imbrenda@linux.ibm.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: elRJbggTJZlC4MbQoU_yWZsWKyMGCKG_
X-Proofpoint-GUID: sTzPxBihS7Xac6J-eYnpFK_pA4J7oHzb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-07_06,2022-06-07_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 spamscore=0 bulkscore=0 adultscore=0 impostorscore=0 malwarescore=0
 mlxlogscore=959 clxscore=1015 priorityscore=1501 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206070054
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  3 Jun 2022 17:40:36 +0200
Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:

> The skey test currently uses a cleanup function to work around the
> issues that arise when the lowcore is not mapped, since the interrupt
> handler needs to access it.
> 
> Instead of a cleanup function, simply disable DAT for the interrupt
> handler for the tests that remap page 0. This is needed in preparation
> of and upcoming patch that will cause the interrupt handler to read
> from lowcore before calling the cleanup function.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
