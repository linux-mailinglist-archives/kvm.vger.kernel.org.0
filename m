Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7031168A925
	for <lists+kvm@lfdr.de>; Sat,  4 Feb 2023 10:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjBDJIP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Feb 2023 04:08:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjBDJIN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Feb 2023 04:08:13 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08BEC19F20;
        Sat,  4 Feb 2023 01:08:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TKwAUDcTJPnaGbcRYAq1msm/KPgHYV1OegkVyHA/hIg=; b=EAIv3YZQ1IiHkbtB00OBp5t8c0
        uOpXlRQ5ZcXbnqtpumJTiENv5XRBPlrjVTmU3oipCRU+iLiUp6lvnPjldv71phTwO1GP+AM6+RQi1
        D8YxHOsEdezJVZ4TJdPhoyeYH6eAB0YqgOEhfu4h+2JQBFxRLfTBFrmnQ6r1DoEDPh2N8lbjqkyLe
        Jik1gElTtCT0lK3yqBulXUdI6N5+6ikCiAt0joFY385YM78/WsNVfXChkXkf7DTodJx6ZfG9WjpxG
        4URgXVmdgnoZJu2A5XpOKbZiyxtk+FcymynOmFF8BpxD5X+ddbFCRZB48TruRTe2bQP2pLYmKrpgy
        8U/kmQJg==;
Received: from [2001:8b0:10b:5::bb3] (helo=u3832b3a9db3152.ant.amazon.com)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pOEW3-00F3b6-Gq; Sat, 04 Feb 2023 09:07:24 +0000
Message-ID: <970faea15f724939dbae47d309bffcb92d12c6c2.camel@infradead.org>
Subject: Re: [PATCH v6 07/11] x86/smpboot: Disable parallel boot for AMD CPUs
From:   David Woodhouse <dwmw2@infradead.org>
To:     Kim Phillips <kim.phillips@amd.com>,
        Usama Arif <usama.arif@bytedance.com>, tglx@linutronix.de,
        arjan@linux.intel.com
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, Mario Limonciello <Mario.Limonciello@amd.com>
Date:   Sat, 04 Feb 2023 09:07:21 +0000
In-Reply-To: <b3d9fbbf-e760-5d1d-9182-44c144abd1bf@amd.com>
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
         <20230202215625.3248306-8-usama.arif@bytedance.com>
         <b3d9fbbf-e760-5d1d-9182-44c144abd1bf@amd.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-ssbNaxIjiinJLAw7EyQy"
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-ssbNaxIjiinJLAw7EyQy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2023-02-03 at 13:48 -0600, Kim Phillips wrote:
> +Mario
>=20
> Hi,
>=20
> On 2/2/23 3:56 PM, Usama Arif wrote:
> > From: David Woodhouse <dwmw@amazon.co.uk>
> >=20
> > Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> > ---
>=20
> I'd like to nack this, but can't (and not because it doesn't have
> commit text):
>=20
> If I:
>=20
> =C2=A0 - take dwmw2's parallel-6.2-rc6 branch (commit 459d1c46dbd1)
> =C2=A0 - remove the set_cpu_bug(c, X86_BUG_NO_PARALLEL_BRINGUP) line from=
 amd.c
>=20
> Then:
>=20
> =C2=A0 - a Ryzen 3000 (Picasso A1/Zen+) notebook I have access to fails t=
o boot.
> =C2=A0 - Zen 2,3,4-based servers boot fine
> =C2=A0 - a Zen1-based server doesn't boot.
>=20
> This is what's left on its serial port:
>=20
> [=C2=A0=C2=A0=C2=A0 3.199633] smp: Bringing up secondary CPUs ...
> [=C2=A0=C2=A0=C2=A0 3.200732] x86: Booting SMP configuration:
> [=C2=A0=C2=A0=C2=A0 3.204242] .... node=C2=A0 #0, CPUs:=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 #1
> [=C2=A0=C2=A0=C2=A0 3.204301] CPU 1 to 93/x86/cpu:kick in 63 21 -11401430=
7645 0 . 0 0 0 0 . 0 114025055970
> [=C2=A0=C2=A0=C2=A0 3.204478] ------------[ cut here ]------------
> [=C2=A0=C2=A0=C2=A0 3.204481] WARNING: CPU: 0 PID: 1 at arch/x86/kernel/c=
pu/common.c:2122 cpu_init+0x2d/0x1f0
> [=C2=A0=C2=A0=C2=A0 3.204490] Modules linked in:
> [=C2=A0=C2=A0=C2=A0 3.204493] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6=
.2.0-rc6+ #19
> [=C2=A0=C2=A0=C2=A0 3.204496] Hardware name: AMD Corporation Speedway/Spe=
edway, BIOS RSW1009C 07/27/2018
> [=C2=A0=C2=A0=C2=A0 3.204498] RIP: 0010:cpu_init+0x2d/0x1f0
> [=C2=A0=C2=A0=C2=A0 3.204502] Code: e5 41 56 41 55 41 54 53 65 48 8b 1c 2=
5 80 2e 1f 00 65 44 8b 35 20 e4 39 55 48 8b 05 5d f7 51 02 44 89 f2 f0 48 0=
f ab 10 73 06 <0f> 0b eb 02 f3 90 48 8b 05 3e f7 51 02 48 0f a3 10 73 f1 45=
 85 f6
> [=C2=A0=C2=A0=C2=A0 3.204504] RSP: 0000:ffffffffac803d70 EFLAGS: 00010083
> [=C2=A0=C2=A0=C2=A0 3.204506] RAX: ffff8d293eef6e40 RBX: ffff8d1d40010000=
 RCX: 0000000000000008
> [=C2=A0=C2=A0=C2=A0 3.204508] RDX: 0000000000000000 RSI: ffff8d1d1c40b048=
 RDI: ffffffffac566418
> [=C2=A0=C2=A0=C2=A0 3.204509] RBP: ffffffffac803d90 R08: 00000000fffffe14=
 R09: ffff8d1d1c406078
> [=C2=A0=C2=A0=C2=A0 3.204510] R10: ffffffffac803dc0 R11: 0000000000000000=
 R12: 0000000000000000
> [=C2=A0=C2=A0=C2=A0 3.204511] R13: 0000000000000000 R14: 0000000000000000=
 R15: 0000000000000000
> [=C2=A0=C2=A0=C2=A0 3.204512] FS:=C2=A0 0000000000000000(0000) GS:ffff8d1=
d1c400000(0000) knlGS:0000000000000000
> [=C2=A0=C2=A0=C2=A0 3.204514] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 00000=
00080050033
> [=C2=A0=C2=A0=C2=A0 3.204515] CR2: 0000000000000000 CR3: 0000800daec12000=
 CR4: 00000000003100a0
> [=C2=A0=C2=A0=C2=A0 3.204517] Call Trace:
> [=C2=A0=C2=A0=C2=A0 3.204519] ---[ end trace 0000000000000000 ]---
> [=C2=A0=C2=A0=C2=A0 3.204580] [Firmware Bug]: CPU0: APIC id mismatch. Fir=
mware: 0 APIC: 2


So this is where it all starts to go wrong, and we didn't really change
this in the less-tested later part of the series. So even though I'd
like to be sure you've tested with just '-part1' to be sure, I suspect
that isn't the issue.

The warning you highlighted the end of the end of the log is just
complaining that a given AP is *already* marked as initialized when
it's trying to come up, and that's just fallout of the fact that they
don't know which CPU they are. They *all* come up thinking they're
CPU#0.

So that's weird. Now, what we do in this series is stop *telling* the
AP which CPU# it is in a global variable as we bring them up one at a
time, and instead we let them get their own APIC ID from CPUID leaf 0xb
and look up their per-cpu data that way.

The commit message for 'Support parallel startup of secondary CPUs'
(currently commit 0f52d4eaaf0c) explains that in a bit more detail.

Please could you try parallel-6.2-rc6-part1 with something like this?
If I boot this in qemu with a weird topology to stop it being a 1:1
mapping, I do see a series of BbCcDdDeEeFfIgJh... showing the APIC ID
and CPU# that each AP finds as it starts up.

qemu-system-x86_64 -kernel arch/x86/boot/bzImage -smp 24,sockets=3D4,cores=
=3D3,threads=3D2 -append "console=3DttyS0,115200 lpj=3D16528321 earlyprintk=
=3DttyS0" -serial mon:stdio -display none -m 1G -accel kvm,kernel-irqchip=
=3Dsplit

...
[    0.570022] x86: Booting SMP configuration:
BbCc[    0.570923] .... node  #0, CPUs:        #1  #2
[    0.711468] Callback from call_rcu_tasks_rude() invoked.
DdEe[    0.713316]   #3  #4
[    0.854459] Callback from call_rcu_tasks() invoked.
FfIgJhKiLjMkNlQmRnSoTpUqVrYsZt[u\v]w^x[    0.856289]   #5  #6  #7  #8  #9 #=
10 #11 #12 #13 #14 #15 #16 #17 #18 #19 #20 #21 #22 #23



diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index d07f694691d2..c3219dc2a201 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -247,8 +247,8 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_G=
LOBAL)
 	 * Is this the boot CPU coming up? If so everything is available
 	 * in initial_gs, initial_stack and early_gdt_descr.
 	 */
-	movl	smpboot_control(%rip), %eax
-	testl	%eax, %eax
+	movl	smpboot_control(%rip), %edx
+	testl	%edx, %edx
 	jz	.Lsetup_cpu
=20
 	/*
@@ -259,30 +259,45 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L=
_GLOBAL)
 	 * Bit 30	STARTUP_SECONDARY flag
 	 * Bit 31	STARTUP_PARALLEL flag (use CPUID 0x0b for APIC ID)
 	 */
-	testl	$STARTUP_PARALLEL, %eax
+	testl	$STARTUP_PARALLEL, %edx
 	jnz	.Luse_cpuid_0b
-	andl	$0x0FFFFFFF, %eax
+	andl	$0x0FFFFFFF, %edx
 	jmp	.Lsetup_AP
=20
 .Luse_cpuid_0b:
 	mov	$0x0B, %eax
 	xorl	%ecx, %ecx
 	cpuid
-	mov	%edx, %eax
+
+/* test hack: print 'a' + APICID */
=20
 .Lsetup_AP:
-	/* EAX contains the APICID of the current CPU */
+	/* EDX contains the APICID of the current CPU */
+
+	/* Test hack: Print APIC ID and then CPU# when we find it. */
+	mov	%edx, %ecx
+	mov	%edx, %eax
+	addb	$'A', %al
+	mov	$0x3f8, %dx
+	outb    %al, %dx
+	mov	%ecx, %edx
+	mov	$'a', %al
+
 	xorl	%ecx, %ecx
 	leaq	cpuid_to_apicid(%rip), %rbx
=20
 .Lfind_cpunr:
-	cmpl	(%rbx), %eax
+	cmpl	(%rbx), %edx
 	jz	.Linit_cpu_data
 	addq	$4, %rbx
 	addq	$8, %rcx
+	addb	$1, %al
 	jmp	.Lfind_cpunr
=20
 .Linit_cpu_data:
+	mov	$0x3f8, %dx
+	outb    %al, %dx
+
 	/* Get the per cpu offset */
 	leaq	__per_cpu_offset(%rip), %rbx
 	addq	%rcx, %rbx





--=-ssbNaxIjiinJLAw7EyQy
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCEkQw
ggYQMIID+KADAgECAhBNlCwQ1DvglAnFgS06KwZPMA0GCSqGSIb3DQEBDAUAMIGIMQswCQYDVQQG
EwJVUzETMBEGA1UECBMKTmV3IEplcnNleTEUMBIGA1UEBxMLSmVyc2V5IENpdHkxHjAcBgNVBAoT
FVRoZSBVU0VSVFJVU1QgTmV0d29yazEuMCwGA1UEAxMlVVNFUlRydXN0IFJTQSBDZXJ0aWZpY2F0
aW9uIEF1dGhvcml0eTAeFw0xODExMDIwMDAwMDBaFw0zMDEyMzEyMzU5NTlaMIGWMQswCQYDVQQG
EwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYD
VQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50
aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAyjztlApB/975Rrno1jvm2pK/KxBOqhq8gr2+JhwpKirSzZxQgT9tlC7zl6hn1fXjSo5MqXUf
ItMltrMaXqcESJuK8dtK56NCSrq4iDKaKq9NxOXFmqXX2zN8HHGjQ2b2Xv0v1L5Nk1MQPKA19xeW
QcpGEGFUUd0kN+oHox+L9aV1rjfNiCj3bJk6kJaOPabPi2503nn/ITX5e8WfPnGw4VuZ79Khj1YB
rf24k5Ee1sLTHsLtpiK9OjG4iQRBdq6Z/TlVx/hGAez5h36bBJMxqdHLpdwIUkTqT8se3ed0PewD
ch/8kHPo5fZl5u1B0ecpq/sDN/5sCG52Ds+QU5O5EwIDAQABo4IBZDCCAWAwHwYDVR0jBBgwFoAU
U3m/WqorSs9UgOHYm8Cd8rIDZsswHQYDVR0OBBYEFAnA8vwL2pTbX/4r36iZQs/J4K0AMA4GA1Ud
DwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEF
BQcDBDARBgNVHSAECjAIMAYGBFUdIAAwUAYDVR0fBEkwRzBFoEOgQYY/aHR0cDovL2NybC51c2Vy
dHJ1c3QuY29tL1VTRVJUcnVzdFJTQUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMHYGCCsGAQUF
BwEBBGowaDA/BggrBgEFBQcwAoYzaHR0cDovL2NydC51c2VydHJ1c3QuY29tL1VTRVJUcnVzdFJT
QUFkZFRydXN0Q0EuY3J0MCUGCCsGAQUFBzABhhlodHRwOi8vb2NzcC51c2VydHJ1c3QuY29tMA0G
CSqGSIb3DQEBDAUAA4ICAQBBRHUAqznCFfXejpVtMnFojADdF9d6HBA4kMjjsb0XMZHztuOCtKF+
xswhh2GqkW5JQrM8zVlU+A2VP72Ky2nlRA1GwmIPgou74TZ/XTarHG8zdMSgaDrkVYzz1g3nIVO9
IHk96VwsacIvBF8JfqIs+8aWH2PfSUrNxP6Ys7U0sZYx4rXD6+cqFq/ZW5BUfClN/rhk2ddQXyn7
kkmka2RQb9d90nmNHdgKrwfQ49mQ2hWQNDkJJIXwKjYA6VUR/fZUFeCUisdDe/0ABLTI+jheXUV1
eoYV7lNwNBKpeHdNuO6Aacb533JlfeUHxvBz9OfYWUiXu09sMAviM11Q0DuMZ5760CdO2VnpsXP4
KxaYIhvqPqUMWqRdWyn7crItNkZeroXaecG03i3mM7dkiPaCkgocBg0EBYsbZDZ8bsG3a08LwEsL
1Ygz3SBsyECa0waq4hOf/Z85F2w2ZpXfP+w8q4ifwO90SGZZV+HR/Jh6rEaVPDRF/CEGVqR1hiuQ
OZ1YL5ezMTX0ZSLwrymUE0pwi/KDaiYB15uswgeIAcA6JzPFf9pLkAFFWs1QNyN++niFhsM47qod
x/PL+5jR87myx5uYdBEQkkDc+lKB1Wct6ucXqm2EmsaQ0M95QjTmy+rDWjkDYdw3Ms6mSWE3Bn7i
5ZgtwCLXgAIe5W8mybM2JzCCBhQwggT8oAMCAQICEQDGvhmWZ0DEAx0oURL6O6l+MA0GCSqGSIb3
DQEBCwUAMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYD
VQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNlY3RpZ28g
UlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTIyMDEwNzAw
MDAwMFoXDTI1MDEwNjIzNTk1OVowJDEiMCAGCSqGSIb3DQEJARYTZHdtdzJAaW5mcmFkZWFkLm9y
ZzCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALQ3GpC2bomUqk+91wLYBzDMcCj5C9m6
oZaHwvmIdXftOgTbCJXADo6G9T7BBAebw2JV38EINgKpy/ZHh7htyAkWYVoFsFPrwHounto8xTsy
SSePMiPlmIdQ10BcVSXMUJ3Juu16GlWOnAMJY2oYfEzmE7uT9YgcBqKCo65pTFmOnR/VVbjJk4K2
xE34GC2nAdUQkPFuyaFisicc6HRMOYXPuF0DuwITEKnjxgNjP+qDrh0db7PAjO1D4d5ftfrsf+kd
RR4gKVGSk8Tz2WwvtLAroJM4nXjNPIBJNT4w/FWWc/5qPHJy2U+eITZ5LLE5s45mX2oPFknWqxBo
bQZ8a9dsZ3dSPZBvE9ZrmtFLrVrN4eo1jsXgAp1+p7bkfqd3BgBEmfsYWlBXO8rVXfvPgLs32VdV
NZxb/CDWPqBsiYv0Hv3HPsz07j5b+/cVoWqyHDKzkaVbxfq/7auNVRmPB3v5SWEsH8xi4Bez2V9U
KxfYCnqsjp8RaC2/khxKt0A552Eaxnz/4ly/2C7wkwTQnBmdlFYhAflWKQ03Ufiu8t3iBE3VJbc2
5oMrglj7TRZrmKq3CkbFnX0fyulB+kHimrt6PIWn7kgyl9aelIl6vtbhMA+l0nfrsORMa4kobqQ5
C5rveVgmcIad67EDa+UqEKy/GltUwlSh6xy+TrK1tzDvAgMBAAGjggHMMIIByDAfBgNVHSMEGDAW
gBQJwPL8C9qU21/+K9+omULPyeCtADAdBgNVHQ4EFgQUzMeDMcimo0oz8o1R1Nver3ZVpSkwDgYD
VR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYwFAYIKwYBBQUHAwQGCCsGAQUFBwMC
MEAGA1UdIAQ5MDcwNQYMKwYBBAGyMQECAQEBMCUwIwYIKwYBBQUHAgEWF2h0dHBzOi8vc2VjdGln
by5jb20vQ1BTMFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwuc2VjdGlnby5jb20vU2VjdGln
b1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcmwwgYoGCCsGAQUFBwEB
BH4wfDBVBggrBgEFBQcwAoZJaHR0cDovL2NydC5zZWN0aWdvLmNvbS9TZWN0aWdvUlNBQ2xpZW50
QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFpbENBLmNydDAjBggrBgEFBQcwAYYXaHR0cDovL29j
c3Auc2VjdGlnby5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5mcmFkZWFkLm9yZzANBgkqhkiG9w0B
AQsFAAOCAQEAyW6MUir5dm495teKqAQjDJwuFCi35h4xgnQvQ/fzPXmtR9t54rpmI2TfyvcKgOXp
qa7BGXNFfh1JsqexVkIqZP9uWB2J+uVMD+XZEs/KYNNX2PvIlSPrzIB4Z2wyIGQpaPLlYflrrVFK
v9CjT2zdqvy2maK7HKOQRt3BiJbVG5lRiwbbygldcALEV9ChWFfgSXvrWDZspnU3Gjw/rMHrGnql
Htlyebp3pf3fSS9kzQ1FVtVIDrL6eqhTwJxe+pXSMMqFiN0whpBtXdyDjzBtQTaZJ7zTT/vlehc/
tDuqZwGHm/YJy883Ll+GP3NvOkgaRGWEuYWJJ6hFCkXYjyR9IzCCBhQwggT8oAMCAQICEQDGvhmW
Z0DEAx0oURL6O6l+MA0GCSqGSIb3DQEBCwUAMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3Jl
YXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0
ZWQxPjA8BgNVBAMTNVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJl
IEVtYWlsIENBMB4XDTIyMDEwNzAwMDAwMFoXDTI1MDEwNjIzNTk1OVowJDEiMCAGCSqGSIb3DQEJ
ARYTZHdtdzJAaW5mcmFkZWFkLm9yZzCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALQ3
GpC2bomUqk+91wLYBzDMcCj5C9m6oZaHwvmIdXftOgTbCJXADo6G9T7BBAebw2JV38EINgKpy/ZH
h7htyAkWYVoFsFPrwHounto8xTsySSePMiPlmIdQ10BcVSXMUJ3Juu16GlWOnAMJY2oYfEzmE7uT
9YgcBqKCo65pTFmOnR/VVbjJk4K2xE34GC2nAdUQkPFuyaFisicc6HRMOYXPuF0DuwITEKnjxgNj
P+qDrh0db7PAjO1D4d5ftfrsf+kdRR4gKVGSk8Tz2WwvtLAroJM4nXjNPIBJNT4w/FWWc/5qPHJy
2U+eITZ5LLE5s45mX2oPFknWqxBobQZ8a9dsZ3dSPZBvE9ZrmtFLrVrN4eo1jsXgAp1+p7bkfqd3
BgBEmfsYWlBXO8rVXfvPgLs32VdVNZxb/CDWPqBsiYv0Hv3HPsz07j5b+/cVoWqyHDKzkaVbxfq/
7auNVRmPB3v5SWEsH8xi4Bez2V9UKxfYCnqsjp8RaC2/khxKt0A552Eaxnz/4ly/2C7wkwTQnBmd
lFYhAflWKQ03Ufiu8t3iBE3VJbc25oMrglj7TRZrmKq3CkbFnX0fyulB+kHimrt6PIWn7kgyl9ae
lIl6vtbhMA+l0nfrsORMa4kobqQ5C5rveVgmcIad67EDa+UqEKy/GltUwlSh6xy+TrK1tzDvAgMB
AAGjggHMMIIByDAfBgNVHSMEGDAWgBQJwPL8C9qU21/+K9+omULPyeCtADAdBgNVHQ4EFgQUzMeD
Mcimo0oz8o1R1Nver3ZVpSkwDgYDVR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYw
FAYIKwYBBQUHAwQGCCsGAQUFBwMCMEAGA1UdIAQ5MDcwNQYMKwYBBAGyMQECAQEBMCUwIwYIKwYB
BQUHAgEWF2h0dHBzOi8vc2VjdGlnby5jb20vQ1BTMFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9j
cmwuc2VjdGlnby5jb20vU2VjdGlnb1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1h
aWxDQS5jcmwwgYoGCCsGAQUFBwEBBH4wfDBVBggrBgEFBQcwAoZJaHR0cDovL2NydC5zZWN0aWdv
LmNvbS9TZWN0aWdvUlNBQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFpbENBLmNydDAj
BggrBgEFBQcwAYYXaHR0cDovL29jc3Auc2VjdGlnby5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5m
cmFkZWFkLm9yZzANBgkqhkiG9w0BAQsFAAOCAQEAyW6MUir5dm495teKqAQjDJwuFCi35h4xgnQv
Q/fzPXmtR9t54rpmI2TfyvcKgOXpqa7BGXNFfh1JsqexVkIqZP9uWB2J+uVMD+XZEs/KYNNX2PvI
lSPrzIB4Z2wyIGQpaPLlYflrrVFKv9CjT2zdqvy2maK7HKOQRt3BiJbVG5lRiwbbygldcALEV9Ch
WFfgSXvrWDZspnU3Gjw/rMHrGnqlHtlyebp3pf3fSS9kzQ1FVtVIDrL6eqhTwJxe+pXSMMqFiN0w
hpBtXdyDjzBtQTaZJ7zTT/vlehc/tDuqZwGHm/YJy883Ll+GP3NvOkgaRGWEuYWJJ6hFCkXYjyR9
IzGCBMcwggTDAgEBMIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVz
dGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMT
NVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEA
xr4ZlmdAxAMdKFES+jupfjANBglghkgBZQMEAgEFAKCCAeswGAYJKoZIhvcNAQkDMQsGCSqGSIb3
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjMwMjA0MDkwNzIxWjAvBgkqhkiG9w0BCQQxIgQg7jtNUUKZ
hBNEaMzOiKv1TT5Ngu0YRtvrL8TNR3ENIFwwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgAQUPwFAXzt0ZY0BTPvjAE9A9q0tezFo650
vld9qIkttIjvMhG+6Nj1RziwvS+YTDuIdGx5+0B8zGtLZ52Jn8K4d9SNomFEGbAGojbhvqiQQcd7
G8URK+GdgBPHkppg0zbkhEHFNWLFIs+EojqM49dhX/tMrKoHAG7OLqXkCp64vlbT5f0Aji8vxTkR
ny9xlrGTsUiXDrGt5PnvspPKCZx5ztduSzByCJuU0qDMZyGS9Ijml8ZU8DzC/3mefL7FAjO0akQb
b+rnjE7Y/9eXUrb1O+1ZKege4CdZKMx3VV+Ymjq33rAMxi0ouQlQC4GNf7QSoL9mgfn4h5sZDe0r
bt8zE6CvaHs7mk45T5lFXQDuF/9l1rI0LS3uubo8QxD8M0TIFDDvJgslEk3xwXyg0AR3EFObNx58
UlhrO7Bx5B0WQdhCZUTnINw/LQsiX2wWgaW/PqHZIrcoEPjXZ8O90LTPcuE6/71cOOMcXFT4oX2a
Thy5+ns9W2MobO/lnikQjkxAKzLcxyEymImV+fkH9XhtbvSq93XSMNxS+BDfjagaf5K4JCLMahck
5AVE+dJksgbI8uKWLS/C4uShPYtGFMebhQncn1i4TlkXqGwBQjiYvszBkSjECaYM3xr7MzRMdF6H
BIwaRzu55S16mxewxlakCJ8s0hgUC55CtCupaW96pAAAAAAAAA==


--=-ssbNaxIjiinJLAw7EyQy--
