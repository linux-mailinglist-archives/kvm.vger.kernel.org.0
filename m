Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B30FF604CEA
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 18:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiJSQSH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 12:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiJSQSG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 12:18:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7571D3B471
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 09:18:05 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29JGC5Ov014571
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 16:18:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=OcfhrDBC5XmgrPXDlIJnkzWDInAAeqE3ajI6gjLNrwg=;
 b=m9H7qSHuc9THf8TgtzdQr1R3Qrf1DWmofwiMmd/FMsmAffijHot/PPkCwoPzw7eBhLjX
 q/QuEsvJ+J58gvwOarYuXM1+6lGrrZFWKyeMqKpFymocQPs9L6fswzyAx0nOgZi/29vx
 t9flMheA3gZRCSX3eWrw2K0en9wzoQnOuMutXccD02fWZUpaDXfcJ//Hoq2JNg0Z02nF
 K20afPsrmz78YPMywoy+m11/7UpXLSfflsuYeDKM4JuRyMpVo0XRLKfBYGscpcB+Zcw9
 p09O0RAHvhKb83G0PvKQVIRY8539sIZSoeCex/3SLTrwIi5/Yvz/tPOXjkrOqhxBfbM0 aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kamhx078x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 16:18:05 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29JGE0rD026723
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 16:18:04 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kamhx0781-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 16:18:04 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29JG6DJ9018180;
        Wed, 19 Oct 2022 16:18:02 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3kajmrr5yg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 16:18:01 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29JGHwlB32309868
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Oct 2022 16:17:58 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE099A4055;
        Wed, 19 Oct 2022 16:17:58 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 723F5A404D;
        Wed, 19 Oct 2022 16:17:58 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.239])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 Oct 2022 16:17:58 +0000 (GMT)
Date:   Wed, 19 Oct 2022 18:17:56 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 0/1] s390x: do not enable PV dump
 support by default
Message-ID: <20221019181756.678fcd1e@p-imbrenda>
In-Reply-To: <9cc2b5a0-c097-8fcf-027a-641b04a61ac6@linux.ibm.com>
References: <20221019145320.1228710-1-nrb@linux.ibm.com>
        <20221019171920.455451ea@p-imbrenda>
        <9cc2b5a0-c097-8fcf-027a-641b04a61ac6@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZqTWNpentXnd5eMtKuW-5xRsEFn3JFGn
X-Proofpoint-GUID: 2-e0IkIKkt9P9srmCxOSLFpn33uvuPlp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_09,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 impostorscore=0 mlxscore=0 clxscore=1015 adultscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=999 priorityscore=1501 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210190091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 19 Oct 2022 17:47:36 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 10/19/22 17:19, Claudio Imbrenda wrote:
> > On Wed, 19 Oct 2022 16:53:19 +0200
> > Nico Boehr <nrb@linux.ibm.com> wrote:
> >   
> >> v1->v2:
> >> ---
> >> * add indent to CONFIG_DUMP if in Makefile (thanks Janosch)
> >> * add comment (thanks Janosch)
> >>
> >> Currently, dump support is always enabled by setting the respective
> >> plaintext control flag (PCF). Unfortunately, older machines without
> >> support for PV dump will not start the guest when this PCF is set.  
> > 
> > maybe for the long term we could try to fix the stub generated by
> > genprotimg to check the plaintext flags and the available features and
> > refuse to try to start if the required features are missing.  
> 
> That's not possible on multiple levels:
> * Unsecure G2 does not have stfle 158
> * Dump is a host feature so I'm unsure if it would even be indicated in 
> the guest

fair enough. maybe those are problems that can be somehow fixed in the
(far) future.

for example when loading the blob with diag 308 subcode 8, the host
could reject it with an appropriate error code (since it would fail
to boot anyway)

not something we have to worry about now, though

> 
> > 
> > ideally providing a custom message when generating the image, to be
> > shown if the required features are missing. e.g. for kvm unit test, the
> > custom message could be something like
> > SKIP: $TEST_NAME: Missing hardware features
> > 
> > once that is in place, we could revert this patch  
> 
> Also the host that's using genprotimg might not be PV enabled or even 
> s390x so checking on image generation is no option either.

checking at image generation time is exactly what I did not want.

> 
> >   
> >>
> >> Nico Boehr (1):
> >>    s390x: do not enable PV dump support by default
> >>
> >>   configure      | 11 +++++++++++
> >>   s390x/Makefile | 26 +++++++++++++++++---------
> >>   2 files changed, 28 insertions(+), 9 deletions(-)
> >>  
> >   
> 

