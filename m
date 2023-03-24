Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD0D6C7B75
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 10:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbjCXJcM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 05:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjCXJcL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 05:32:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C563223A54;
        Fri, 24 Mar 2023 02:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wRpXizBGuHdP3epppHw+DGJMeb+XXk28iwr6szkfego=; b=jhEKBZ3o8wIQVmf6/DlROazNey
        TRwVOmVd5lUtKR9MD9Qa8Qu3OUIa4VDun7wJvDTf/kxVqof50NlaPl6BpFtCBKa+3qoW6eEbQd5qd
        g009qnSmOW+N7Ow1l/hGbOZmCz1/+YfVoc15hp1xWxep1UazjVHklwejiKWS2e36mLHExQ2leuzWO
        NccX/icGfPFxHw41Q5JfuvTaFHqeF/hsvt4VxtzaGvNXObfo6VCf4FA7dPBBcKSwYxineIaBfHiFv
        I3iC8vs8/cmsm6dJ7DElt04PPLwJDQk8pnkCq/BVb7p73bl8S+3e1V9WevBdlH2fNp8hPv+P8xBxZ
        kl6OIOKQ==;
Received: from [2001:8b0:10b:5:3a94:98c5:5567:7e7] (helo=u3832b3a9db3152.ant.amazon.com)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pfdlK-004mIy-QC; Fri, 24 Mar 2023 09:31:07 +0000
Message-ID: <115b39e0226915b8f69ea0cce2487588f6010995.camel@infradead.org>
Subject: Re: [PATCH v16 3/8] cpu/hotplug: Add dynamic parallel bringup
 states before CPUHP_BRINGUP_CPU
From:   David Woodhouse <dwmw2@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Usama Arif <usama.arif@bytedance.com>, kim.phillips@amd.com,
        brgerst@gmail.com
Cc:     piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        gpiccoli@igalia.com
Date:   Fri, 24 Mar 2023 09:31:04 +0000
In-Reply-To: <87v8ir6j96.ffs@tglx>
References: <20230321194008.785922-1-usama.arif@bytedance.com>
         <20230321194008.785922-4-usama.arif@bytedance.com> <874jqb8588.ffs@tglx>
         <871qlf83wj.ffs@tglx>
         <8dff6ae5ffaebfbcc55a01c04420fd478070b830.camel@infradead.org>
         <87v8ir6j96.ffs@tglx>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-VpC/vRw3YgADGeHzRDfL"
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-VpC/vRw3YgADGeHzRDfL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2023-03-24 at 02:16 +0100, Thomas Gleixner wrote:
> On Thu, Mar 23 2023 at 23:12, David Woodhouse wrote:
> > On Fri, 2023-03-24 at 00:05 +0100, Thomas Gleixner wrote:
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if =
(ret && can_rollback_cpu(st))
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0WARN_ON(cpuhp_invoke_callback_=
range(false, cpu, st, CPUHP_OFFLINE));
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0}
> >=20
> > And I'll take doing this bit unconditionally (it's basically a no-op if
> > they already got rolled all the way back to CPUHP_OFFLINE, right?).
> >=20
> > But the additional complexity of having multiple steps is fairly
> > minimal, and I'm already planning to *use* another one even in x86, as
> > discussed.
>=20
> It's not about the "complexity". That's a general design question and
> I'm not agreeing with your approach of putting AP specifics into the BP
> state space.
>=20
> The BP only phase ends at the point where the AP is woken up via
> SIPI/INIT/whatever. Period.
>=20
> And no, we are not making this special just because it's the easiest way
> to get it done. I have _zero_ interest in this kind of hackery which
> just slaps stuff into the code where its conveniant without even
> thinking about proper separations
>=20
> We went a great length to separate things clearly and it takes more than
> "oh let's reserve a few special states" to keep this separation
> intact. That's a matter of correctness, maintainability and taste.
>=20
> That microcode thing on X86 has absolutely no business in the pre
> bringup DYN states. It's an AP problem and it can be solved completely
> without BP interaction.

As long as the BP doesn't bring any more siblings online during the
update, sure.

> And before you start drooling over further great parallelism, can you
> please take a step back and come up with a sensible design for the
> actual real world requirments?
>=20
> The point is that after an AP comes out of lala land and starts
> executing there are mandatory synchronization points which need to be
> handled by design. The number of synchronization points is architecture
> and platform specific and might be 0, but thats a detail.
>=20
> So the proper thing is to split CPUHP_BRINGUP_CPU, which is the bridging
> state between AP and BP today, into a set of synchronization points
> between BP and AP.

I feel we're talking past each other a little bit. Because I'd have
said that's *exactly* what this patch set is doing.

The existing x86 CPUHP_BRINGUP_CPU step in native_cpu_up() has a bunch
of back-and-forth between BP and AP, which you've enumerated below and
which I cleaned up and commented in the 'Split up native_cpu_up into
separate phases and document them' patch.

This patch set literally introduces the new PARALLEL_DYN states to be
"a set of synchronization points between BP and AP", and then makes the
x86 code utilise that for the *first* of its back-and-forth exchanges
between BP and AP.

The patch to do the second stage and truly make it a 'set' on x86 is
waiting in the wings, precisely because it *happens* not to catch fire
yet, but hasn't been properly audited yet.

But it seemed to me that you were saying you want us to limit
architectures to just *one* additional step (CPUHP_BP_PARALLEL_STARTUP)
instead of the 'set' that I'd added with the PARALLEL_DYN states? Did I
misunderstand?

> But that's non-trivial because if you look at bringup_cpu() then you'll
> notice that this state has an implicit protection against interrupt
> allocation/free and quite some architectures rely on this for their
> early bringup code and possibly their STARTING state callbacks.

I literally pointed that out in 2021 (in one of the messages I
reference below).

For x86 I don't believe that's going to be an issue yet, if at all. I
think it matters for the lapic_online() call which happens near the end
of start_secondary(); it's almost the last thing it does before going
into the generic AP startup thread. It's *also* preceded by a comment
that at least *suggests* it ought to be fine anyway, although we should
never entirely trust such comments.

        /*
         * Lock vector_lock, set CPU online and bring the vector
         * allocator online. Online must be set with vector_lock held
         * to prevent a concurrent irq setup/teardown from seeing a
         * half valid vector space.
         */
        lock_vector_lock();
        /* Sync point with do_wait_cpu_online() */
        set_cpu_online(smp_processor_id(), true);
        lapic_online();

We're a long way from parallelizing *that* one and needing to check the
veracity of the comment though.

> That aside. Let's just look at x86 as of today from the BP side:
>=20
> =C2=A0=C2=A0=C2=A0 1) Wakeup AP
> =C2=A0=C2=A0=C2=A0 2) Wait until there is sign of life
> =C2=A0=C2=A0=C2=A0 3) Let AP proceed
> =C2=A0=C2=A0=C2=A0 5) Wait until AP is done with init
> =C2=A0=C2=A0=C2=A0 6) TSC synchronization
> =C2=A0=C2=A0=C2=A0 7) Wait until it is online
>=20
> and on the AP side:
>=20
> =C2=A0=C2=A0=C2=A0 1) Do low level init
> =C2=A0=C2=A0=C2=A0 2) Report life
> =C2=A0=C2=A0=C2=A0 3) Wait until BP allows to proceed
> =C2=A0=C2=A0=C2=A0 4) Do init
> =C2=A0=C2=A0=C2=A0 5) Report done
> =C2=A0=C2=A0=C2=A0 6) TSC synchronization
> =C2=A0=C2=A0=C2=A0 7) Report online
>=20
> So surely you could claim that up to #6 (TSC sync) nothing needs to
> synchronize.

I don't think we could claim that at all. There are a whole bunch of
implicit dependencies on the fact that this happens in series, and at
any given point in the sequence we might know that *either* the BP is
free to act, *or* precisely one of the APs is free. For example:

> But that's simply not true because topology information is implicitely
> serialized by CPU hotplug and your attempt to serialize that in patch
> 7/8 is not cutting it at all because AP #4 (STARTING) callbacks rely
> implicitely on the immutability of the topology information

Right, and that's just fine. That patch explicitly calls out that it is
preparation for *future* parallelism. Which is why it's *last* in the
series (well, apart from the SEV-ES bit, which I wanted to be even
*more* last-in-the-series than that).

If it was needed for the "phase 1" parallelism of INIT/SIPI/SIPI that
gets enabled in patch #6, then it would have come before that in the
series.

It is necessary =E2=80=94 but not sufficient, as you correctly point out =
=E2=80=94 for
the *next* stages of parallelism.=20

>  and so do some of the later (threaded) AP callbacks too.
>=20
> As I said before 5 out of 10 callbacks I looked at are not ready for
> this.
>=20
> Just because it did not explode in your face yet, does not make any of
> your wet dreams more correct.

Now you're looking even further into the future. We're not trying to
make the AP startup threads run in parallel yet.

> Again: I'm not interested in this kind of "works for me" nonsense at
> all.

You keep saying that. It's starting to become offensive.

Yes, the first RFC posting of this approach was quite explicitly billed
as 'proof-of-concept hack' and 'don't look too hard because it's only
really for figuring out the timing'. I make no apology for that:
https://lore.kernel.org/lkml/8ac72d7b287ed1058b2dec3301578238aff0abdd.camel=
@infradead.org/

And if you look back at the first actual series that was posted, it's
also very clear about which bit is actually ready because all the
testing and thinking has been done, and which isn't:
https://lore.kernel.org/lkml/478c56af540eaa47b8f452e51cb0c085f26db738.camel=
@infradead.org/

So please, stop giving me this "\"works for me\" nonsense" nonsense.

Yes, there are some patches on top of this lot that aren't ready yet;
we've fixed up *some* of the things that actually broke, and only done
a cursory pass of actually inspecting it to make sure it's safe. And
some of your observations above are very relevant and helpful to when
we come to do *that* part of the thinking.

But we aren't asking you to merge those parts yet. We have deliberately
cut it back to the initial stage because that's where the biggest win
is, and there's *enough* thinking to be done just for this part.

We will review your comments and be happy to engage in further robust
discussion about the future patches when we get round to that (if
indeed we conclude that there's a significant win to be had from them).

In the meantime, if there are specific things which are wrong with the
parallelism introduced by *this* patch series that you're trying to
point out to us, then I apologise; I've missed them.

--=-VpC/vRw3YgADGeHzRDfL
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjMwMzI0MDkzMTA0WjAvBgkqhkiG9w0BCQQxIgQgcC+5m0dA
C3HWFh5OUOiOHDafyJiVjVZzUjo0/f9pwMMwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgAWotwJ0iGWNVkiiqWjfpuCAiQHBYkb0RV2
Ksy3fIUl16oGNe1wi8nytecasYLl1uXEOPkVbKvACa8DlRtKqNtwtdgtJcccPAloJrjM9mV18Ib8
zADXDphEw9YC50foM22SKb7Jt1mJoHIzy2Lfe8jI9fkuYFNP/83fhaKqy/EvPGo4667hsbm8ORYV
6BKzOGx8KNl1nsW/gaoV7KMWrcbPcznk128Gk6XDxGVrZgEM/QW47isu4p7HwqUgY46FbxZAlfRi
7L1WX2eMHI4vbpTwvIdJnfs6nGNV7uPS3aFi+Sz2rYLUuKc30X0hnYtSxPvAcSw7Y3GyyWEt/n/j
XOWD2ncLrBr+WflM6ejuxjj4KSo+NT0obxffphEb121G2l9xp2ZA8TVioNmRFvDyPKQpJK0tzW+2
doWC7ah+6rmHmHPKKSFeAKlf8Lx1x+IXbblMG7TpeaiFuWW+1CQtYGA1c0njjcA12um8E+GD/+zb
4x9QqVgSNalzHWPMbrb6xvG8Oro7GJI8155ufVPOgclN6P2/UCKHNxkP6ZfKJ7o6aXu2ahFDMsxo
x3xYSG/+wFc9VdwJ49vS5RQXPAGFOBcDs1I42w66mLuuAfgNcHVWc7v6kg2iZRRsMD8wCmoiwLgp
uGoR/PQ2HBZB5ss+PBx+QNiq976oW0MbUQ1JmAKCqAAAAAAAAA==


--=-VpC/vRw3YgADGeHzRDfL--
