Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0835E6F706E
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 19:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjEDRHL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 13:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjEDRHJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 13:07:09 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C66135AE
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 10:07:07 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 344H3817029701;
        Thu, 4 May 2023 17:06:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : content-transfer-encoding : mime-version; s=pp1;
 bh=bCfEs44O59JogdS5BpuwlqVU+dmACMM9SfBh6S4pUX0=;
 b=aGQcS9Y1iKkjBxAy+uJmNGSTMCDFYNKAV+qc9A+VZba/IniFqx5Bp0eIaPBDwqbFVRn7
 KBmJWxYIr/K1f5LhU4DbZDNVgjldO6JRfRjSXzmex5s8AcnPnzFtv0T3DGbiLXXVRQdg
 70CXZ/QhQadGorGTeGqz8JE5iWsrWwJKIOc4lM7S58yZji4SI2zJgWlx/BKHkzxNJrrU
 jVrNxD8ZyEBPU3dK8Icm6phNN0yGXG30jb1A7/IEoLMUNY7f/a0rXakry0LSkQ1PPyMi
 MfiMJKUQu5rUg50DmM6q8uRPl/YX3oUpliloI3UR89a2vadJJ5K+KUkEPDcOy9DItDE8 6A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qcgs087kd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 May 2023 17:06:50 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 344H4AD5002057;
        Thu, 4 May 2023 17:05:09 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qcgs082fr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 May 2023 17:05:08 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 344FAIKZ008611;
        Thu, 4 May 2023 17:04:13 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([9.208.130.98])
        by ppma04dal.us.ibm.com (PPS) with ESMTPS id 3q8tv8h485-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 May 2023 17:04:12 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 344H4BmU63898064
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 May 2023 17:04:11 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BFF5558057;
        Thu,  4 May 2023 17:04:11 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC4B05805D;
        Thu,  4 May 2023 17:04:10 +0000 (GMT)
Received: from lingrow.int.hansenpartnership.com (unknown [9.211.131.5])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  4 May 2023 17:04:10 +0000 (GMT)
Message-ID: <614e66054c58048f2f43104cf1c9dcbc8745f292.camel@linux.ibm.com>
Subject: Re: [ANNOUNCEMENT] COCONUT Secure VM Service Module for SEV-SNP
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     =?ISO-8859-1?Q?J=F6rg_R=F6del?= <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Klaus Kiwi <kkiwi@redhat.com>, linux-coco@lists.linux.dev,
        kvm@vger.kernel.org, amd-sev-snp@lists.suse.com
Date:   Thu, 04 May 2023 13:04:09 -0400
In-Reply-To: <ZFJTDtMK0QqXK5+E@suse.de>
References: <ZBl4592947wC7WKI@suse.de>
         <4420d7e5-d05f-8c31-a0f2-587ebb7eaa20@amd.com> <ZFJTDtMK0QqXK5+E@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kdfIoJheiL8N26zq2rnPEfHDa29dII_G
X-Proofpoint-GUID: Ji_cchR4b7C7AGBkuUicstgNWcHIfOU7
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-04_10,2023-05-04_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 mlxscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 clxscore=1015 phishscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305040139
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-05-03 at 14:26 +0200, Jörg Rödel wrote:
> On Tue, May 02, 2023 at 06:03:55PM -0500, Tom Lendacky wrote:
[...]
> >   - On the subject of priorities, the number one priority for the
> >     linux-svsm project has been to quickly achieve production
> > quality vTPM support. The support for this is being actively worked
> > on by linux-svsm contributors and we'd want to find fastest path
> > towards getting that redirected into coconut-svsm (possibly
> > starting with CPL0
> >     implementation until CPL3 support is available) and the project
> >     hardened for a release.  I imagine there will be some competing
> >     priorities from coconut-svsm project currently, so wanted to
> > get this out on the table from the beginning.
> 
> That has been under discussion for some time, and honestly I think
> the approach taken is the main difference between linux-svsm and
> COCONUT. My position here is, and that comes with a big 'BUT', that I
> am not fundamentally opposed to having a temporary solution for the
> TPM until CPL-3 support is at a point where it can run a TPM module.

OK, so this, for IBM, is directly necessary.  We have the vTPM pull
request about ready to go and we'll probably send it still to the AMD
SVSM.  Given that the AMD SVSM already has the openssl library and the
attestation report support, do you want to pull them into coconut
directly so we can base a coconut vTPM pull request on that?

> And here come the 'BUT': Since the goal of having one project is to
> bundle community efforts, I think that the joint efforts are better
> targeted at getting CPL-3 support to a point where it can run
> modules. On that side some input and help is needed, especially to
> define the syscall interface so that it suits the needs of a TPM
> implementation.

Crypto support in ring-0 is unavoidable if we want to retain control of
the VMPCK0 key in ring-0.  I can't see us giving it to ring-3 because
that would give up control of the SVSM identity and basically make the
ring-0 separation useless because you can compromise ring-3 and get the
key and then communicate with the PSP as the SVSM.

I think the above problem also indicates no-one really has a fully
thought out security model that shows practically how ring-3 improves
the security posture.  So I really think starting in ring-0 and then
moving pieces to ring-3 and discussing whether this materially improves
the security posture based on the code and how it operates gets us
around the lack of understanding of the security model because we
proceed by evolution.

The next question that's going to arise is *where* the crypto libraries
should reside.  Given they're somewhat large, duplicating them for
every cpl-3 application plus cpl-3 seems wasteful, so some type of vdso
model sounds better (and might work instead of a syscall interfaces for
cpl-0 services that are pure code).  

> It is also not the case that CPL-3 support is out more than a year or
> so. The RamFS is almost ready, as is the archive file inclusion[1].
> We will move to task management next, the goal is still to have basic
> support ready in 2H2023.
> 
> [1] https://github.com/coconut-svsm/svsm/pull/27

Well, depending on how you order them, possibly.  The vTPM has a simple
request/response model, so it really doesn't have much need of a
scheduler for instance.  And we could obviously bring up cpl-3 before a
module loader/ram filesystem and move to that later.

> If there is still a strong desire to have COCONUT with a TPM (running
> at CPL-0) before CPL-3 support is usable, then I can live with
> including code for that as a temporary solution. But linking huge
> amounts of C code (like openssl or a tpm lib) into the SVSM rust
> binary kind of contradicts the goals which made us using Rust for
> project in the first place. That is why I only see this as a
> temporary solution.

I'm not sure it will be.  If some cloud or distro wants to shoot for
FIPS compliance of the SVSM, for instance, a requirement will likely be
to use a FIPS certified crypto library ... and they're all currently in
C.  That's not to say we shouldn't aim for minimizing the C
dependencies, but I don't see a "pure rust or else" approach
facilitating the initial utility of the project.

James




