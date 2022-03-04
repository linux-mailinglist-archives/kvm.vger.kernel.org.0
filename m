Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29ECD4CD621
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 15:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237986AbiCDOQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 09:16:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237143AbiCDOQd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 09:16:33 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5252DD9;
        Fri,  4 Mar 2022 06:15:45 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 224DFXvN030862;
        Fri, 4 Mar 2022 14:15:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=7uw0EfO0RjH37PsknsZA8clY1MYsNZHMfhygHZ6thr4=;
 b=TTpSqwep8KzOB0edjCzZe5Ber6Pz22ZEuXO8ZqHs8i2GR7GyUTp2KrkLK5+DWXnG2DyD
 NlOz5tT44rgkL+WFsePFJ5qkp/RblJAX0Sx4zg8XJDRVwogVvtUD616HBiN8CRU45Y1y
 OoSHvSbrT812M8yRq8m8AK3KwqVmfl6+MdYy0cJzvmMmxiUT1qYTrZGy7GPUeM0enShh
 edBedYc0sCZdbNZ2lOxiciYyCgUGb8GwBrOOjJ/IPMYYrKVrD/PofdgON1RwYZQSuwlv
 eRfsREM1LDoBYXMcryy4/u62QhEVq8tgtHaZjDQXUkJXxPmiYR3L1mHDieOUBgpb+Nb6 bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ekgwgv9km-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 14:15:45 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 224DULQr011334;
        Fri, 4 Mar 2022 14:15:44 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ekgwgv9ka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 14:15:44 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 224E7gIt019361;
        Fri, 4 Mar 2022 14:15:43 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03wdc.us.ibm.com with ESMTP id 3ek4ken69e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 14:15:43 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 224EFfZ816319030
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Mar 2022 14:15:42 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2623BE059;
        Fri,  4 Mar 2022 14:15:41 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E2E5BE04F;
        Fri,  4 Mar 2022 14:15:41 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.148.123])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  4 Mar 2022 14:15:41 +0000 (GMT)
Message-ID: <8917a0c37981194a147e4b83940926adb5738106.camel@linux.ibm.com>
Subject: Re: [PATCH kvm-unit-tests v1 6/6] lib: s390x: smp: Convert
 remaining smp_sigp to _retry
From:   Eric Farman <farman@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Fri, 04 Mar 2022 09:15:40 -0500
In-Reply-To: <1aa3b683-061d-465a-89fa-2c748719564d@linux.ibm.com>
References: <20220303210425.1693486-1-farman@linux.ibm.com>
         <20220303210425.1693486-7-farman@linux.ibm.com>
         <1aa3b683-061d-465a-89fa-2c748719564d@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ULBEKtPGe7VFsUA6KOuLxeX7BnV2eL72
X-Proofpoint-ORIG-GUID: pBT6BOX-5faN8B5kinI1ko2hCrBBJ3VG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_06,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203040077
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-04 at 11:56 +0100, Janosch Frank wrote:
> On 3/3/22 22:04, Eric Farman wrote:
> > A SIGP SENSE is used to determine if a CPU is stopped or operating,
> > and thus has a vested interest in ensuring it received a CC0 or
> > CC1,
> > instead of a CC2 (BUSY). But, any order could receive a CC2
> > response,
> > and is probably ill-equipped to respond to it.
> 
> sigp sense running status doesn't return a cc2, only sigp sense does
> afaik.

The KVM routine handle_sigp_dst() returns the CC2 if a STOP/RESTART IRQ
is pending for any non-reset order, before it gets to the switch
statement that would route to the SIGP SENSE RUNNING handler.

> Looking at the KVM implementation tells me that it's not doing more
> than 
> looking at the R bit in the sblk.
> 
> > In practice, the order is likely to only encounter this when racing
> > with a SIGP STOP (AND STORE STATUS) or SIGP RESTART order, which
> > are
> > unlikely. But, since it's not impossible, let's convert the library
> > calls that issue a SIGP to loop on CC2 so the callers do not need
> > to react to that possible outcome.
> > 
> > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > ---
> >   lib/s390x/smp.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> > index 85b046a5..2e476264 100644
> > --- a/lib/s390x/smp.c
> > +++ b/lib/s390x/smp.c
> > @@ -85,7 +85,7 @@ bool smp_cpu_stopped(uint16_t idx)
> >   
> >   bool smp_sense_running_status(uint16_t idx)
> >   {
> > -	if (smp_sigp(idx, SIGP_SENSE_RUNNING, 0, NULL) !=
> > SIGP_CC_STATUS_STORED)
> > +	if (smp_sigp_retry(idx, SIGP_SENSE_RUNNING, 0, NULL) !=
> > SIGP_CC_STATUS_STORED)
> >   		return true;
> >   	/* Status stored condition code is equivalent to cpu not
> > running. */
> >   	return false;
> > @@ -169,7 +169,7 @@ static int smp_cpu_restart_nolock(uint16_t idx,
> > struct psw *psw)
> >   	 * running after the restart.
> >   	 */
> >   	smp_cpu_stop_nolock(idx, false);
> > -	rc = smp_sigp(idx, SIGP_RESTART, 0, NULL);
> > +	rc = smp_sigp_retry(idx, SIGP_RESTART, 0, NULL);
> >   	if (rc)
> >   		return rc;
> >   	/*

