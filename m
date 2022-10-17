Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60833600DC3
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 13:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiJQL3W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 07:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbiJQL27 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 07:28:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBAA962AB4
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 04:28:58 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29HB4MFo026859
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 11:28:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=LueS6Kgsiv/d4YXCQqE1qYxj2iq8w7j2wiqtOSPsOYk=;
 b=JjrDeCN907XRkikQRfqe/pYlIpBwIusKy/ysdOukJCCBCNedLUfPhtybm66EyIb3AIYX
 plv7VS9ACaRG00DXZgwJcs/+CB1QhddSVh1rbMCAYyywyvq3ZPhImCpLEvI1MdjJTPVm
 19ONyA0T2hzcegjnO2/LX2vL8J3d2Kd0DvP7atdelcLKL+7g8BA5lnvs3+PzEDZiE5r9
 MNC57Srva5hwWaUD2uO9wwFF98d/4h30kRnqamn0QSmsh2uWVF/ozMrmPA3SmLFPh312
 Rh9+dPXkwvNHa3BVbwhoTtUJIzJaW2K6KppA7cZZke0NUjDOINgW2wc1lCheDqDqbyS+ sA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k865vy2n4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 11:28:58 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29HAspA7023313
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 11:28:58 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k865vy2m8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Oct 2022 11:28:58 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29HBMEhP001627;
        Mon, 17 Oct 2022 11:28:55 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3k7mg9269e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Oct 2022 11:28:55 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29HBSqaS3867210
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Oct 2022 11:28:52 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37EAF4C04E;
        Mon, 17 Oct 2022 11:28:52 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC07A4C044;
        Mon, 17 Oct 2022 11:28:51 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.239])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Oct 2022 11:28:51 +0000 (GMT)
Date:   Mon, 17 Oct 2022 13:28:49 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v7 0/1] s390x: Add exit time test
Message-ID: <20221017132849.45b3def9@p-imbrenda>
In-Reply-To: <20221017101828.703068-1-nrb@linux.ibm.com>
References: <20221017101828.703068-1-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HubeN_lEF1mxFtw_vaIQOC6ekj59FOEz
X-Proofpoint-ORIG-GUID: GodF-O66oh-AfFfGuA2_xX2FHIfq_-X7
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-17_09,2022-10-17_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 spamscore=0 suspectscore=0 clxscore=1015 impostorscore=0
 mlxscore=0 priorityscore=1501 bulkscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210170064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 17 Oct 2022 12:18:27 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

thanks, picked

> v6->v7:
> ---
> * change info message to indicate normalization and number of iterations
>   normalized to (thanks Claudio)
> 
> v5->v6:
> ---
> * multiply first, then divide when normalizing (thanks Claudio)
> * print fractions of us (thanks Claudio)
> * remove non-normalized output (thanks Claudio)
> * fence dag9c since not supported under TCG
> 
> v4->v5:
> ---
> * print normalized runtime to be able to compare runtime of
>   instructions in a single run (thanks Claudio)
> 
> v3->v4:
> ---
> * remove merge conflict markers (thanks Christian)
> 
> v2->v3:
> ---
> * print average (thanks Claudio)
> * have asm constraints look the same everywhere (thanks Claudio)
> * rebase patchset on top of my migration sck patches[1] to make use of the
>   time.h improvements
> 
> v1->v2:
> ---
> * add missing cc clobber, fix constraints for get_clock_us() (thanks
>   Thomas)
> * avoid array and use pointer to const char* (thanks Thomas)
> * add comment why testing nop makes sense (thanks Thomas)
> * rework constraints and clobbers (thanks Thomas)
> 
> Sometimes, it is useful to measure the exit time of certain instructions
> to e.g. identify performance regressions in instructions emulated by the
> hypervisor.
> 
> This series adds a test which executes some instructions and measures
> their execution time. Since their execution time depends a lot on the
> environment at hand, all tests are reported as PASS currently.
> 
> The point of this series is not so much the instructions which have been
> chosen here (but your ideas are welcome), but rather the general
> question whether it makes sense to have a test like this in
> kvm-unit-tests.
> 
> This series is based on my migration sck patches[1] to make use of the
> time.h improvements there.
> 
> [1] https://lore.kernel.org/all/20221011170024.972135-1-nrb@linux.ibm.com/
> 
> Nico Boehr (1):
>   s390x: add exittime tests
> 
>  s390x/Makefile      |   1 +
>  s390x/exittime.c    | 296 ++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |   4 +
>  3 files changed, 301 insertions(+)
>  create mode 100644 s390x/exittime.c
> 

