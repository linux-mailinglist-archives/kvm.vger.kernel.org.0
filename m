Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C18D6F9222
	for <lists+kvm@lfdr.de>; Sat,  6 May 2023 14:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbjEFMs2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 May 2023 08:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231964AbjEFMs1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 May 2023 08:48:27 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56C415EDD
        for <kvm@vger.kernel.org>; Sat,  6 May 2023 05:48:25 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 346Ccdl0019695;
        Sat, 6 May 2023 12:48:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=bLJAmkON5hLP1gbAP5AvmIeFW8n7hNTmtULujssg9Yc=;
 b=DkF4stT3ui/2spIF8/8huNwSxWPIvfSAfFrm7+p6b2ydU2/kTgcSHqTUphHiDKv2dD+W
 mO4F//SlNtQuwr/mNSCJN+VRG9OWleWIRMPqZCl5i3DPolBBdUBCvtNUtbqBU8JpsKfl
 hNlnC9+oxrY8jP9mS0Afu1QIun0+avZfSKM2b1dNPdK4Zdbp/0Ii3Ikix49mg5WhyIXR
 xCE0qeMtkmDAWDK5q9hQILPWcKbyIaKeuBXe7Y30RhYVTDAYw1iGVjOSabWp9POBhMsJ
 QpzYocGRJd2QzRe+frRAzuTMkMvZDT2O30Y9cAktl9rBJVpiwbyj/icBS6Y8i7XWld2I dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qdk9yutca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 06 May 2023 12:48:09 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 346CgJ99029862;
        Sat, 6 May 2023 12:48:09 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qdk9yutc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 06 May 2023 12:48:09 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3467uvXo023232;
        Sat, 6 May 2023 12:48:08 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([9.208.129.120])
        by ppma03wdc.us.ibm.com (PPS) with ESMTPS id 3qdeh71qw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 06 May 2023 12:48:08 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 346Cm7rw4719258
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 6 May 2023 12:48:07 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 085765805D;
        Sat,  6 May 2023 12:48:07 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB36258057;
        Sat,  6 May 2023 12:48:05 +0000 (GMT)
Received: from [10.249.64.78] (unknown [9.211.131.5])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Sat,  6 May 2023 12:48:05 +0000 (GMT)
Message-ID: <2f1c0527ab42dee7d4eaf562c6a14851bb64c341.camel@linux.ibm.com>
Subject: Re: [ANNOUNCEMENT] COCONUT Secure VM Service Module for SEV-SNP
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Christophe de Dinechin <dinechin@redhat.com>
Cc:     =?ISO-8859-1?Q?J=F6rg_R=F6del?= <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Klaus Kiwi <kkiwi@redhat.com>, linux-coco@lists.linux.dev,
        kvm@vger.kernel.org, amd-sev-snp@lists.suse.com
Date:   Sat, 06 May 2023 08:48:04 -0400
In-Reply-To: <m25y95j2gg.fsf@redhat.com>
References: <ZBl4592947wC7WKI@suse.de>
         <4420d7e5-d05f-8c31-a0f2-587ebb7eaa20@amd.com> <ZFJTDtMK0QqXK5+E@suse.de>
         <614e66054c58048f2f43104cf1c9dcbc8745f292.camel@linux.ibm.com>
         <m25y95j2gg.fsf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hBkZWXJhRWWTpzc3qik8FqOWvdJCIcZi
X-Proofpoint-ORIG-GUID: 0b8fYZFslf-ZzBiU8GnMv4YyVbUYAkIC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-06_08,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 clxscore=1015 malwarescore=0 spamscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305060097
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2023-05-05 at 14:35 +0200, Christophe de Dinechin wrote:
> 
> On 2023-05-04 at 13:04 -04, James Bottomley <jejb@linux.ibm.com>
> wrote...
> > On Wed, 2023-05-03 at 14:26 +0200, Jörg Rödel wrote:
[...]
> > > And here come the 'BUT': Since the goal of having one project is
> > > to bundle community efforts, I think that the joint efforts are
> > > better targeted at getting CPL-3 support to a point where it can
> > > run modules. On that side some input and help is needed,
> > > especially to define the syscall interface so that it suits the
> > > needs of a TPM implementation.
> > 
> > Crypto support in ring-0 is unavoidable if we want to retain
> > control of the VMPCK0 key in ring-0.  I can't see us giving it to
> > ring-3 because that would give up control of the SVSM identity and
> > basically make the ring-0 separation useless because you can
> > compromise ring-3 and get the key and then communicate with the PSP
> > as the SVSM.
> 
> I'm a but confused regarding the roles that VMPL vs rings is in the
> security model here.

Heh, I think that goes for everyone, which is why I'm fishing for
information about the security model.  I don't think its enough to
blindly claim running at cpl3 gives more security, you have to have a
threat model that demonstrates it.

>  In particular, I assume that any attack on ring3 would
> still have to cross either the VMPL boundary (if coming from the
> guest) or the TEE boundary (if coming from the host).

I think the attack theory is more like a privilege escalation: you
induce the SVSM to take a fault through its normal API mechanism by
crafting bad data (this means the runtime attack can only come from the
guest since the host doesn't get access to the SVSM at runtime,
although it could craft bad configuration data for boot time).

Assuming a successful exploit, the attacker now has the ability to run
code in the compromised module.  For a unitary SVSM, that would give
control of the entire SVSM.  For ring 0/3 separation, it should only
give control of the compromised module, which we're assuming is ring 3
code.  However, you're right, in that the attacker now has the ability
to execute VPML0 code, except that some privileged instructions (like
PVALIDATE) can only execute at ring 0, so the attack ability is
slightly more limited.

I've always considered the gold standard exploit of the SVSM to be one
that allows you to fake attestation reports, since then it's game over
as far as remote verification goes, which is why I want the VMPCK0 key
(the communication key VPML0 uses to get VMPL0 specific attestation
reports from the PSP) to be closely guarded at ring 0, making it harder
to compromise remote attestation via exploits.

The flip side is that, assuming the vTPM is the compromised service,
you've already got the ability to fake TPM based runtime attestation,
so its still game over from the remote attestation point of view.  This
leads me to conclude that it really doesn't matter where security
critical protocols run, and the only real advantage of the ring 0/3
separation would come into play if the SVSM had some non-security
critical protocols and it's not clear if it ever will.

> > I think the above problem also indicates no-one really has a fully
> > thought out security model that shows practically how ring-3
> > improves the security posture.  So I really think starting in ring-
> > 0 and then moving pieces to ring-3 and discussing whether this
> > materially improves the security posture based on the code and how
> > it operates gets us around the lack of understanding of the
> > security model because we proceed by evolution.
> 
> And there is definitely a lot of complexity added by supporting
> ring3. You are essentially getting the complexity of a "real"
> operating system.  By contrast, TDX is providing the same kind of
> isolation with secure enclaves, but at least the base OS kernel is
> shared.
> 
> The expected benefit is to be able to run more complex code from
> ring3 with a better way to handle malfunctions, faults, whatever. At
> least that's the way I read it. So it's a way to write software in a
> more modular way.

Yes, but is that a benefit?  If one of the protocol modules faults, I
think you'd rather have a hard failure of the whole confidential VM
than a restart that gives an attacker more leeway to craft a
compromise.

> IIUC, the ring-3 modules of the SVSM would still be at VMPL0, so
> presumably, not accesible from host or guest. If we consider this
> property as strong, then do we really care entrusting ring3 with
> sensitive data?

Well, as I said above, I think for security critical modules, it
doesn't matter where they run, so perhaps we don't care, but equally
there's not much security benefit to ring 0/3 separation either.

> > The next question that's going to arise is *where* the crypto
> > libraries should reside.  Given they're somewhat large, duplicating
> > them for every cpl-3 application plus cpl-3 seems wasteful, so some
> > type of vdso model sounds better (and might work instead of a
> > syscall interfaces for cpl-0 services that are pure code).
> 
> I don't understand what you call "pure code". I presume you mean
> "code that does not need to access ring0 data"?

I was meaning a VDSO like model, where the openssl crypto code could be
exported from ring-0 as an executable library, but the data would live
with the corresponding consumer, so it could be used by the SVSM body
at ring-0 with any crypto data being held at ring-0 and inaccessible to
ring-3 consumers of the crypto code.

James

