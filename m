Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791D66E12E6
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 18:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjDMQ56 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 12:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjDMQ55 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 12:57:57 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B4D59F9
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 09:57:55 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33DG2OI5027566;
        Thu, 13 Apr 2023 16:57:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=D5yWcGIgmRhATTU255ihuSPwo0baBTJ7jksurRFuZ+g=;
 b=mk1w9WnZUKuqL3ILXvLilMJL0se8GJaoizyp1CuvknGwp8V9/lmnC6Boasb72A27ty7g
 eQ6kSH/r0xQipXwEECzTNxdqMTELog5QlWf1FZDUC2BHCZoPC1BUF/kUxFSDgxlwZWoE
 hE5dT1JS7d93v55usw3QZgOgNIyLbOmD9TDnEtv2bPt8z0U0d2a4g++Skma/5rdGM3UJ
 WwWerV3w0jiB9JvgdgQxFBr9o/bixjJ8t1DFRTpGYiESlg0nhyJAAe4vfIHCb/5ArfWa
 rTcGs1WuWnC4xzNPMUdPWbJX30RjPGjKnh/TTuyEfbZrPYzQ5CSQc4k1G+Mq316QXSfq zg== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pxjn0hjrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Apr 2023 16:57:42 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33DGTTvM020834;
        Thu, 13 Apr 2023 16:57:41 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([9.208.130.102])
        by ppma04wdc.us.ibm.com (PPS) with ESMTPS id 3pu0jhcg58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Apr 2023 16:57:41 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33DGve8O10420780
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Apr 2023 16:57:40 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C301C58058;
        Thu, 13 Apr 2023 16:57:40 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1091958057;
        Thu, 13 Apr 2023 16:57:40 +0000 (GMT)
Received: from lingrow.int.hansenpartnership.com (unknown [9.211.87.50])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 13 Apr 2023 16:57:39 +0000 (GMT)
Message-ID: <5ab2bca5dab750cce82df5e28db5ebb8f657e3ed.camel@linux.ibm.com>
Subject: Re: [ANNOUNCEMENT] COCONUT Secure VM Service Module for SEV-SNP
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        =?ISO-8859-1?Q?J=F6rg_R=F6del?= <jroedel@suse.de>,
        amd-sev-snp@lists.suse.com, linux-coco@lists.linux.dev,
        kvm@vger.kernel.org
Date:   Thu, 13 Apr 2023 12:57:38 -0400
In-Reply-To: <bf7f82ab-3cd3-a5f6-74ec-270d3ca6c766@amd.com>
References: <ZBl4592947wC7WKI@suse.de>
         <bf7f82ab-3cd3-a5f6-74ec-270d3ca6c766@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: G6IPjah4Ll5JGw14d5KhHRAs-Ml2m2qk
X-Proofpoint-GUID: G6IPjah4Ll5JGw14d5KhHRAs-Ml2m2qk
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-13_12,2023-04-13_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 spamscore=0 mlxscore=0 clxscore=1011 lowpriorityscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304130147
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2023-04-11 at 14:57 -0500, Tom Lendacky wrote:
> On 3/21/23 04:29, Jörg Rödel wrote:
> > Hi,
> > 
> > We are happy to announce that last week our secure VM service
> > module (SVSM) went public on GitHub for everyone to try it out and
> > participate in its further development. It is dual-licensed under
> > the MIT and APACHE-2.0 licenses.
> > 
> > The project is written in Rust and can be cloned from:
> > 
> >         https://github.com/coconut-svsm/svsm
> > 
> > There are also repositories in the github project with the Linux
> > host and guest, EDK2 and QEMU changes needed to run the SVSM and
> > boot up a full Linux guest.
> > 
> > The SVSM repository contains an installation guide in the
> > INSTALL.md file and contributor hints in CONTRIBUTING.md.
> > 
> > A blog entry with more details is here:
> > 
> >         https://www.suse.com/c/suse-open-sources-secure-vm-service-
> > module-for-confidential-computing/
> > 
> > We also thank AMD for implementing and providing the necessary
> > changes to Linux and EDK2 to make an SVSM possible.
> 
> Just wanted to let everyone know that I'm looking into what we can do
> to  move towards a single SVSM project so that resources aren't split
> between  the two.
> 
> I was hoping to have a comparison, questions and observations between
> the two available by now, however, I'm behind on that... but, I am
> working on it.

We (IBM) did look at what it might take to add a vTPM to Coconut, but
we ran into the problem that if we do it at CPL3 (which looks
desirable), then we have to wait until pretty much every one of the
twelve(!) tasks in this list is complete:

https://github.com/coconut-svsm/svsm/issues/16

At a conservative estimate, it looks like completion of all twelve
would take a team of people over a year to achieve.  Some of these
tasks, like task switching and a syscall interface, really don't look
like they belong in a simple service module, like we were imagining an
SVSM would operate, is there some rationale behind this (or ideally
some architecture document that gives the justifications)?  I think
what I'm really asking is can we get to CPL3 separation way sooner than
completion of all these tasks?

Regards,

James


