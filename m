Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43A0C6C3B37
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 21:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbjCUUGD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 16:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjCUUGB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 16:06:01 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9D426A6
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 13:05:55 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32LIXUd5016684;
        Tue, 21 Mar 2023 20:05:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=ixwo8rFfOE7dCM9YBZU/EfkMPgOIFTuk724F+quK0ZM=;
 b=P8wxjup4Jo/sYX592knQ/DTk0RTopR3f4qIFbZoc8G7Hd+FK/gKTsXzA98uzvCDxDUfL
 47lWYsENsQYQ/IJkF9sgiA+n/f1vem2XON06Ldb852opPfv0QMlVYbdQ+cQs+UabWskL
 Ouz9mW/YOkuzCo03H96kYyPJOGnIc7BGa9wPu43TeuLuzM2yKDv2x528x1BcpDYJaRaM
 sZFEDcO9u1Do4NRcMB8f3/YiFT1yW1uOGP3Le3U9XmWF9xGHGKMUW6lK3hDbM9A8dgMS
 +zp3KBA762G8nr/p4BQcDBOYTFqtJBIQPJL08DRsQGFFyvUGJyx/L3kYsjKtlS48/6Jp fg== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pf9249hjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Mar 2023 20:05:41 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32LJ8xJ8020743;
        Tue, 21 Mar 2023 20:05:40 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([9.208.129.120])
        by ppma04dal.us.ibm.com (PPS) with ESMTPS id 3pd4x79jd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Mar 2023 20:05:40 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32LK5d3V18416188
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 20:05:39 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 296A758065;
        Tue, 21 Mar 2023 20:05:39 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86F7D58061;
        Tue, 21 Mar 2023 20:05:38 +0000 (GMT)
Received: from nat-wireless-guest-reg-153-54.bu.edu (unknown [9.163.23.201])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 21 Mar 2023 20:05:38 +0000 (GMT)
Message-ID: <7d615af4c6a9e5eeb0337d98c9e9ddca6d2cbdef.camel@linux.ibm.com>
Subject: Re: [ANNOUNCEMENT] COCONUT Secure VM Service Module for SEV-SNP
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     =?ISO-8859-1?Q?J=F6rg_R=F6del?= <jroedel@suse.de>
Cc:     amd-sev-snp@lists.suse.com, linux-coco@lists.linux.dev,
        kvm@vger.kernel.org
Date:   Tue, 21 Mar 2023 16:05:35 -0400
In-Reply-To: <ZBnJ6ZCuQJTVMM8h@suse.de>
References: <ZBl4592947wC7WKI@suse.de>
         <66eee693371c11bbd2173ad5d91afc740aa17b46.camel@linux.ibm.com>
         <ZBmmjlNdBwVju6ib@suse.de>
         <c2e8af835723c453adaba4b66db533a158076bbf.camel@linux.ibm.com>
         <ZBnJ6ZCuQJTVMM8h@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DxOMIW6msPBOJFKA97GFJXokRTIqj3ai
X-Proofpoint-ORIG-GUID: DxOMIW6msPBOJFKA97GFJXokRTIqj3ai
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-21_11,2023-03-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 clxscore=1015
 impostorscore=0 mlxscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303210159
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2023-03-21 at 16:14 +0100, Jörg Rödel wrote:
> On Tue, Mar 21, 2023 at 09:43:48AM -0400, James Bottomley wrote:
> > Could you describe these incompatible goals and explain why you
> > think they are incompatible (as in why you and AMD don't think you
> > can agree on it)?  That would help the rest of us understand where
> > the two SVSM implementations fit in our ongoing plans.
> 
> The goal of COCONUT is to have an SVSM which has isolation
> capabilities within itself. It already has percpu page-tables and in
> the end it will be able to run services (like the TPM) as separate
> processes in ring 3 using cooperative multitasking.
> 
> With the current linux-svsm code-base this is difficult to achieve
> due to its reliance on the x86-64 crate. For supporting a user-space
> like execution mode the crate has too many limitations, mainly in its
> page-table and IDT implementations.
> 
> The IDT code from that crate, which is also used in linux-svsm,
> relies on compiler-generated entry-code. This is not enough to
> support a ring-3 execution mode with syscalls and several (possibly
> nested) IST vectors. The next problem with the IDT code is that it
> doesn't allow modification of return register state.  This makes it
> impossible to implement exception fixups to guard RMPADJUST
> instructions and VMPL1 memory accesses in general.
> 
> When we looked at the crate, the page-table implementation supported
> basically a direct and an offset mapping, which will get us into
> problems when support for non-contiguous mappings or sharing parts of
> a page-table with another page-table is needed. So in the very
> beginning of the project I decided to go with my own page-table
> implementation.

OK, so this doesn't sound like a problem with the AMD svsm, it sounds
like a (solvable) issue with a particular crate in embedded rust.  I
have to say that embedded rust is so new, it's really hard to tell if
this is just because it was developed by someone who didn't think of
all the OS implications or because it's a fundamental issue within the
rust ecosystem.  Have you tried improving this crate? ... and also it's
a nuisance we came to with our insistence on using rust; it certainly
wouldn't have been an issue in C.  I suspect improving the crate would
help everyone (although I note the linux kernel isn't yet using this
crate either).

> Of course we could start changing linux-svsm to support the same
> goals, but I think the end result will not be very different from
> what COCONUT looks now.

That's entirely possible, so what are the chances of combining the
projects now so we don't get a split in community effort?

James

