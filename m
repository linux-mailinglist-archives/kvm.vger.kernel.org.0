Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E67B68A616
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 23:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbjBCWZc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 17:25:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbjBCWZa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 17:25:30 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE1C1BACF;
        Fri,  3 Feb 2023 14:25:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=h+dofN7AvtEcOE3bZG2QIdw7rXUp+edTNNxUoSc5sp4=; b=g16tqrYOVX1wmqEuaTQ0B+pQ1D
        in6mOK09iUWUUSpfdRQiZG0FIO/glVsLRYFv7w1Nz7FFfoIp8EvWYVCNvD77lVaIVlzOC2bmoP1fS
        H7xSOA8u30BGnxmeiUORW7RXnPPCRU3EDV4kI3p8mj216NAGQv/lzrV8rxzYdU5Cm45y+PTEToi4K
        kTPiFaN8s+fVAEY7Dbzl+9usa0RzCubym9TiIUtOx61y7hkBAQWRDpFTAwL3pq2qHgVP5JoyQy+eS
        //n8dXPdgA5lZk0Ur0A3MLR7X05ILtacfIbMY8LxHH76xUT2hCT1hBAKaIZ9Vy2vlSb9eAvCJFfl+
        pVfpcKFg==;
Received: from [2001:8b0:10b:5::bb3] (helo=u3832b3a9db3152.ant.amazon.com)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pO4UT-00Eh72-3j; Fri, 03 Feb 2023 22:25:05 +0000
Message-ID: <503eabcd1bed64ecc54b9af5a4d906251ca024db.camel@infradead.org>
Subject: Re: [EXTERNAL][PATCH v6 07/11] x86/smpboot: Disable parallel boot
 for AMD CPUs
From:   David Woodhouse <dwmw2@infradead.org>
To:     Kim Phillips <kim.phillips@amd.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "usama.arif@bytedance.com" <usama.arif@bytedance.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "Mario.Limonciello@amd.com" <Mario.Limonciello@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "fam.zheng@bytedance.com" <fam.zheng@bytedance.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "liangma@liangbit.com" <liangma@liangbit.com>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "mimoja@mimoja.de" <mimoja@mimoja.de>,
        "hewenliang4@huawei.com" <hewenliang4@huawei.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "punit.agrawal@bytedance.com" <punit.agrawal@bytedance.com>,
        "simon.evans@bytedance.com" <simon.evans@bytedance.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Date:   Fri, 03 Feb 2023 22:25:03 +0000
In-Reply-To: <54fb46ad-10b7-dc87-5723-5437fe5f40a3@amd.com>
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
         <20230202215625.3248306-8-usama.arif@bytedance.com>
         <b3d9fbbf-e760-5d1d-9182-44c144abd1bf@amd.com>
         <d5ec64236ba75f0d3f3718fb69b2cb9169d8af0a.camel@amazon.co.uk>
         <54fb46ad-10b7-dc87-5723-5437fe5f40a3@amd.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-mQwDO6ti/7xHVgbzFquS"
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


--=-mQwDO6ti/7xHVgbzFquS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2023-02-03 at 15:45 -0600, Kim Phillips wrote:
> On 2/3/23 2:19 PM, Woodhouse, David wrote:
> > Would be interesting to know if that goes away if you test only the
> > first part of the tree. My first inclination is to suspect that's a bug
> > in the later patches... although the APIC ID mismatch is interesting.
> > That part (with each AP getting its own APIC ID from CPUID) is in the
> > *first* part of the series....
>=20
> dwmw2/parallel-6.2-rc6-part1 (commit 942b3faa258c) re-enabled for
> AMD gets the same splat(s):

Sure that's the right image? Looks like it still has the timing debug
patch from the last commit in the tree?


> [=C2=A0=C2=A0=C2=A0 3.195498] smp: Bringing up secondary CPUs ...
> [=C2=A0=C2=A0=C2=A0 3.196670] x86: Booting SMP configuration:
> [=C2=A0=C2=A0=C2=A0 3.200189] .... node=C2=A0 #0, CPUs:=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 #1
> [=C2=A0=C2=A0=C2=A0 3.200247] CPU 1 to 93/x86/cpu:kick in 315 42 -1552065=
75216 0 . 0 0 0 0 . 0 155217324423
> [=C2=A0=C2=A0=C2=A0 3.200418] ------------[ cut here ]------------
> [=C2=A0=C2=A0=C2=A0 3.200420] WARNING: CPU: 0 PID: 1 at arch/x86/kernel/c=
pu/common.c:2122 cpu_init+0x2d/0x1f0
> [=C2=A0=C2=A0=C2=A0 3.200428] Modules linked in:
> [=C2=A0=C2=A0=C2=A0 3.200430] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6=
.2.0-rc6+ #19
> [=C2=A0=C2=A0=C2=A0 3.200433] Hardware name: AMD Corporation Speedway/Spe=
edway, BIOS RSW1009C 07/27/2018
> [=C2=A0=C2=A0=C2=A0 3.200435] RIP: 0010:cpu_init+0x2d/0x1f0
> [=C2=A0=C2=A0=C2=A0 3.200438] Code: e5 41 56 41 55 41 54 53 65 48 8b 1c 2=
5 80 2e 1f 00 65 44 8b 35 20 e4 99 47 48 8b 05 5d f7 51 02 44 89 f2 f0 48 0=
f ab 10 73 06 <0f> 0b eb 02 f3 90 48 8b 05 3e f7 51 02 48 0f a3 10 73 f1 45=
 85 f6
> [=C2=A0=C2=A0=C2=A0 3.200440] RSP: 0000:ffffffffba203d70 EFLAGS: 00010083
> [=C2=A0=C2=A0=C2=A0 3.200443] RAX: ffff8e027eef6e40 RBX: ffff8dfe80064b80=
 RCX: 0000000000000008
> [=C2=A0=C2=A0=C2=A0 3.200444] RDX: 0000000000000000 RSI: ffff8df65c40b048=
 RDI: ffffffffb9f66418
> [=C2=A0=C2=A0=C2=A0 3.200445] RBP: ffffffffba203d90 R08: 00000000fffffe4d=
 R09: ffff8df65c406078
> [=C2=A0=C2=A0=C2=A0 3.200446] R10: ffffffffba203dc0 R11: 0000000000000000=
 R12: 0000000000000000
> [=C2=A0=C2=A0=C2=A0 3.200447] R13: 0000000000000000 R14: 0000000000000000=
 R15: 0000000000000000
> [=C2=A0=C2=A0=C2=A0 3.200448] FS:=C2=A0 0000000000000000(0000) GS:ffff8df=
65c400000(0000) knlGS:0000000000000000
> [=C2=A0=C2=A0=C2=A0 3.200450] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 00000=
00080050033
> [=C2=A0=C2=A0=C2=A0 3.200451] CR2: 0000000000000000 CR3: 0000800307e12000=
 CR4: 00000000003100a0
> [=C2=A0=C2=A0=C2=A0 3.200453] Call Trace:
> [=C2=A0=C2=A0=C2=A0 3.200454] ---[ end trace 0000000000000000 ]---
> [=C2=A0=C2=A0=C2=A0 3.200509] [Firmware Bug]: CPU0: APIC id mismatch. Fir=
mware: 0 APIC: 2
> [=C2=A0=C2=A0=C2=A0 3.284620]=C2=A0=C2=A0=C2=A0 #2
> [=C2=A0=C2=A0=C2=A0 3.284669] CPU 2 to 93/x86/cpu:kick in 252 42 -1555476=
68514 0 . 0 0 0 0 . 0 155548597197
> [=C2=A0=C2=A0=C2=A0 3.284727] ------------[ cut here ]------------
> [=C2=A0=C2=A0=C2=A0 3.284732] WARNING: CPU: 0 PID: 1 at arch/x86/kernel/c=
pu/common.c:2122 cpu_init+0x2d/0x1f0
> [=C2=A0=C2=A0=C2=A0 3.284741] Modules linked in:
> [=C2=A0=C2=A0=C2=A0 3.284745] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 6.2.0-rc6+ #19
> [=C2=A0=C2=A0=C2=A0 3.284749] Hardware name: AMD Corporation Speedway/Spe=
edway, BIOS RSW1009C 07/27/2018
> [=C2=A0=C2=A0=C2=A0 3.284752] RIP: 0010:cpu_init+0x2d/0x1f0
> [=C2=A0=C2=A0=C2=A0 3.284756] Code: e5 41 56 41 55 41 54 53 65 48 8b 1c 2=
5 80 2e 1f 00 65 44 8b 35 20 e4 99 47 48 8b 05 5d f7 51 02 44 89 f2 f0 48 0=
f ab 10 73 06 <0f> 0b eb 02 f3 90 48 8b 05 3e f7 51 02 48 0f a3 10 73 f1 45=
 85 f6
> [=C2=A0=C2=A0=C2=A0 3.284760] RSP: 0000:ffffffffba203d70 EFLAGS: 00010083
> [=C2=A0=C2=A0=C2=A0 3.284764] RAX: ffff8e027eef6e40 RBX: ffff8dfe80064b80=
 RCX: 0000000000000008
> [=C2=A0=C2=A0=C2=A0 3.284766] RDX: 0000000000000000 RSI: ffff8df65c40b048=
 RDI: ffffffffb9f66418
> [=C2=A0=C2=A0=C2=A0 3.284769] RBP: ffffffffba203d90 R08: 00000000fffffe4d=
 R09: ffff8df65c406078
> [=C2=A0=C2=A0=C2=A0 3.284771] R10: ffffffffba203dc0 R11: 0000000000000000=
 R12: 0000000000000000
> [=C2=A0=C2=A0=C2=A0 3.284773] R13: 0000000000000000 R14: 0000000000000000=
 R15: 0000000000000000
> [=C2=A0=C2=A0=C2=A0 3.284775] FS:=C2=A0 0000000000000000(0000) GS:ffff8df=
65c400000(0000) knlGS:0000000000000000
> [=C2=A0=C2=A0=C2=A0 3.284778] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 00000=
00080050033
> [=C2=A0=C2=A0=C2=A0 3.284779] CR2: 0000000000000000 CR3: 0000800307e12000=
 CR4: 00000000003100a0
> [=C2=A0=C2=A0=C2=A0 3.284781] Call Trace:
> [=C2=A0=C2=A0=C2=A0 3.284783] ---[ end trace 0000000000000000 ]---
> [=C2=A0=C2=A0=C2=A0 3.284841] [Firmware Bug]: CPU0: APIC id mismatch. Fir=
mware: 0 APIC: 8
> [=C2=A0=C2=A0=C2=A0 3.364[[=C2=A0=C2=A0 [. 343 35=C2=A0=C2=A0=C2=A0=C2=A0=
 5 5] [=C2=A0 3 364575=C2=A0 [
> =C2=A0 3 [=C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 [3 3 [ [=C2=A0 3
>=20
> Thanks,
>=20
> Kim


--=-mQwDO6ti/7xHVgbzFquS
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjMwMjAzMjIyNTAzWjAvBgkqhkiG9w0BCQQxIgQg6E85fJCT
LFZLcyEZCCugfGBGB5S5JahUC0GeydWhVDEwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgCXIyWayo2GZI7HSCcBA69mtx41mKZDnBtT
326iTl24m90ymIz0c2+ufMy8K1CKoT75ubx67hlyGqP0cPtXx94exmVrqB/zz6dpchNQp8+ITViR
A39xfQk00jIYuTV5KN5HpvqumdzAtpA71dEdXvt5eCxz356BkPa4VSIvaqSDJ9apmwoGHVpG0949
4m93e7bjs1BgNiNBz3222TWLsE9X23Eg84onccpERFX2bs1r66CWX3MLrrSS+8NL3i2smu08+X+C
E8RR37kLPxJUOC5si+1qYzW8FaQCkADttW5EmVGYNrWaC8QgfpmgmEkt4vm4PfGtDVIhf+mn2AUu
LS6sVzl8C5Y6Z0Hb1BoZbdPZX0DPJvccAF57/ed6uxQ92C5x9+6MV1Du2i74WQKbRz3+L0wLsEfh
XhmW+OoU2UvLKYJhUHGi2YFZjGzZ2W02ElQa72C6y30R7cn5wpBGkKWCr0go4+EFMHJBmHoFd1pk
rDD+TvfhexMIRJO9KYk+BlB45pArWJDLOQHswAuE5XalySYdY/gq+rbYqVepVbKkx+tr3FijDviB
4D6gNMpFVz1iyTK476b3I9rTcG+X4YKTNJz4lXGT8zNrdAu+vDJXUwzgJz86rHUF5ZaUQwVRtrsq
fgEp+9u6ty5feN7ynvgE6OyUocs4Fq7+ZFQeScN6KgAAAAAAAA==


--=-mQwDO6ti/7xHVgbzFquS--
