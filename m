Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 985C54E6FC1
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 10:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346129AbiCYJFu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 05:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiCYJFs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 05:05:48 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F05CCD33A
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 02:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=y2fLPuxRSYJgwXCAZ+ZLYve1wuzZus2TuRDKwbyA5zc=; b=L28RNlomk+yyJfbfwbkNBnB/gd
        3B5mrkMZxT/SvoEc7OLNYmRWD0SS3IUxFkgzOUy+Pr+rzWSt8Jn4zGZ5gSKDNB2JDvRxJsioxoevi
        99OC4V4R3dGujUe5RkSTONMtPrRP3gz3es8ZPk3kNJKSJeASnLzbnRzjM219Na/jICl8Zly0ZsLzL
        4Fl80PWKo0wlH/fnhBtqgW7UDEq8Q1wJVIb+BsO5cUDHAPMAq2Wu2IKEU+6o0/MXAOBdsF2stgVp6
        MduErc566OPwKlEChW0xtFAdkELnud+Y6dt6gbxdWWczRESS7QPOkniIz1bOaHdfgtuaL5h5irKLC
        JkP4e/nA==;
Received: from [2001:8b0:10b:1:4a2a:e3ff:fe14:8625] (helo=u3832b3a9db3152.ant.amazon.com)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nXfrM-004KQc-On; Fri, 25 Mar 2022 09:03:52 +0000
Message-ID: <2dd68865688a0a3d49501598f524bcc63ded7b08.camel@infradead.org>
Subject: Re: [PATCH] Documentation: KVM: Describe guest TSC scaling in
 migration algorithm
From:   David Woodhouse <dwmw2@infradead.org>
To:     Oliver Upton <oupton@google.com>
Cc:     "Franke, Daniel" <dff@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date:   Fri, 25 Mar 2022 09:03:50 +0000
In-Reply-To: <YjtJCDvLAXphkxhK@google.com>
References: <5BD1FCB2-3164-4785-B4D0-94E19E6D7537@amazon.com>
         <YjpFP+APSqjU7fUi@google.com>
         <9fe6ac14df519ca8df42d3a7fd54ee0c49c58922.camel@infradead.org>
         <YjtJCDvLAXphkxhK@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-qo6KIGRu5Uk7pIb1ehjF"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-qo6KIGRu5Uk7pIb1ehjF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2022-03-23 at 16:21 +0000, Oliver Upton wrote:
> On Wed, Mar 23, 2022 at 12:35:17PM +0000, David Woodhouse wrote:
> > And it all looks *just* like it would if the vCPUs happened not to be
> > scheduled for a little while, because the host was busy.
>=20
> We could continue to get away with TSC advancement, but the critical
> part IMO is the upper bound. And what happens when we exceed it.
>=20
> There is no authoritative documentation around what time looks like as a
> guest of KVM, and futhermore what happens when a guest experiences time
> travel. Now we're in a particularly undesirable situation where there
> are at least three known definitions for time during a migration
> (upstream QEMU, Google, Amazon) and it is ~impossible to program guest
> software to anticipate our shenanigans.
>=20
> If we are to do this right we probably need to agree on documented
> behavior. If we decide that advancing TSCs is acceptable up to 'X'
> seconds, guest kernels could take a change to relax expectations at
> least up to this value.

I'm not sure I even buy this line of argument at all. I don't think of
it as 'TSC advancement'. Or maybe I should put that the other way
round: TSCs advance *all* the time; that's the whole point in them.=20

All we do when we live-migrate is move the state from one host to
another, completely intact. From the guest point of view we don't
"advance" the TSC; we just set the guest TSC on the destination host to
precisely=C2=B9 the same value that the guest TSC on the source host would
have at that moment if we were to abort the migration and do a
rollback. Either way (rollback or not), the vCPUs weren't *running* for
a period of time, but time and TSCs are entirely the same.

In fact, on live update we literally *don't* change anything that the
guest sees. The pvclock information that the guest gets is *precisely*
the same as before, and the TSC has 'advanced' purely by nature of
being precisely the same CPU just a short period of time in the
future... because that's what TSCs do when time passes :)

Really, we aren't talking about a "maximum advancement of the TSC".
We're talking about a "maximum period for which the vCPUs aren't
scheduled".

And I don't see why there need to be documented hard limits on that. I
see it as a quality of implementation issue. If the host is in swap
death and doesn't manage to run the guest vCPUs for seconds at a time,
that's fairly crappy, but it's not strictly a *timekeeping* issue. And
it's just the same if the final transition period of live migration (or
the kexec time for live update) is excessive.

> > > > The KVM_PVCLOCK_STOPPED event should trigger a change in some of th=
e
> > > > globals kept by kernel/time/ntp.c (which are visible to userspace t=
hrough
> > > > adjtimex(2)). In particular, `time_esterror` and `time_maxerror` sh=
ould get reset
> > > > to `NTP_PHASE_LIMIT` and time_status should get reset to `STA_UNSYN=
C`.
> > >=20
> > > I do not disagree that NTP needs to throw the book out after a live
> > > migration.
> > >=20

Right. To recap, this is because where I highlighted 'precisely=C2=B9'
above, our accuracy is actually limited to the synchronisation of the
wallclock time between the two hosts. If the guest thinks it has a more
accurate NTP sync than either of the hosts do, we may have introduced
an error which is more than the error bounds the guest thinks it has,
and that may ultimately lead to data corruption in some circumstances.

This part is somewhat orthogonal to the above discussion, isn't it?
Regardless of whether we 'step' the TSC or not, we need to signal the
guest to know that it needs to consider itself unsynchronized (or, if
we want to get really fancy, let it know the upper bounds of the error
we just introduced. But let's not).

> > > But, the issue is how we convey that to the guest. KVM_PVCLOCK_STOPPE=
D
> > > relies on the guest polling a shared structure, and who knows when th=
e
> > > guest is going to check the structure again? If we inject an interrup=
t
> > > the guest is likely to check this state in a reasonable amount of tim=
e.
> >=20
> > Ah, but that's the point. A flag in shared memory can be checked
> > whenever the guest needs to know that it's operating on valid state.
> > Linux will check it *every* time from pvclock_clocksource_read().
> >=20
> > As opposed to a separate interrupt which eventually gets processed some
> > indefinite amount of time in the future.
>=20
> There are a few annoying things with pvclock, though. It is a per-vCPU
> structure, so special care must be taken to act exactly once on a
> migration. Also, since commit 7539b174aef4 ("x86: kvmguest: use TSC
> clocksource if invariant TSC is exposed") the guest kernel could pick
> the TSC over the pvclock by default, so its hard to say when the pvclock
> structure is checked again.

That commit appears to be assuming that the TSC *will* be "stepped", or
as I call it "continue to advance normally at its normal frequency over
elapsed time".

>  This is what I had in mind when suggesting a doorbell is needed, as
> there is no good way to know what clocksource the guest is using.

Yes, perhaps that might be necessary.

The concern is that by the time that doorbell interrupt has finally
been delivered and processed, an inaccurate timestamp could *already*
have been used on the wire in the some application's coherency
protocol, and the guest's database could already be hosed.

But I don't see why we can't have both.  I think it makes sense for the
guest kernel to ditch its NTP sync when it sees PVCLOCK_GUEST_STOPPED,
but I'm not entirely averse to the existence of a doorbell mechanism
such as you describe.

> > I'll give you the assertion that migrations aren't completely
> > invisible, but I still think they should be *equivalent* to the vCPU
> > just not being scheduled for a moment.
>=20
> I sure hope that migrations are fast enough that it is indistinguishable
> from scheduler pressure. I think the situations where that is not the
> case are particularly interesting. Defining a limit and having a
> mechanism for remedial action could make things more predictable for
> guest software.
>=20
> But agree, and shame on us for the broken virtual hardware when that
> isn't the case :-)

Right. The "how to tell the guest that it needs to ditch its NTP sync
status" question needs some more thought but in the short term I think
it makes sense to add get/set TSC mechanisms which work like
KVM_[SG]ET_CLOCK with the KVM_CLOCK_REALTIME flag.

Instead of realtime though, it should use the KVM clock. So reading a
TSC returns a { kvm_ns, TSC value } tuple, and setting it will advance
the value by the appropriate amount just as we advance the KVM clock
for the KVM_CLOCK_REALTIME delta.



--=-qo6KIGRu5Uk7pIb1ehjF
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjIwMzI1MDkwMzUwWjAvBgkqhkiG9w0BCQQxIgQgkAyOmviT
0xlOLESPBBtNYBa5l9gyfjE3oX/DHd3aWkIwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgAiQBnO8OGkVdd7mXl1R77H2uAYArGsuLqD
ZALh9Si6AdywiKj+oIXBpgqYCW5yVg5WkXaj5wyd3+4oGl8vV66s+GidATPtpdjZCQcVoovm7G3g
wEyJzkeH9L8Ibsi0305B3uGiXGnaUuaDCIhmCVNLTvP8qSuVI4zGslA7c72ahzWlU/TqsL81S66c
rzgV9zRbAdSOsNNmGQwBzLT8R7lwFgVOQi4vpkMZr2v43TWMSDIguaLPmYLCOD5VntVEAMgL8dKV
fc7xJFwZ45mbuBTJeC25fJqhHreBzVXqomqPwPfTQdfPLMH2RDMhv8LUsGDXzQI1rLaxfdtxnsCd
K45m1TANnQLgvYaWeRi/mwkEhB54gu/dYvpLrImYprpZoyQxbfdbS99zO9hzzJULVj9rno67hIxL
c0QzvA+wakWISDQ509YdJMNat0bRPTHV1gxCmEnL1dUx43wErMbOSvstVajf0qT/ydhh+b9Z0Lpr
IH9BdsNJ6h3Wr5rpVRyr18rVYuCtJ/9PkevhATCB4YWc2sJKJ36GsM282lFNtBVhAU6g0B0t2z3P
wxMuYeC1zXp7vqp6iCLfIuTIQxj1cHhWuDQPhG3bwm2xOLfM4jmk0OSLGBOyFQg9rQesNuUCGbgv
kerDIUk2H8Un64VyLl67X3vQTyqIG66NA1o4jxjKdQAAAAAAAA==


--=-qo6KIGRu5Uk7pIb1ehjF--

