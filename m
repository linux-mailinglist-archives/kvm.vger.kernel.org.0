Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4F817B6B8A
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 16:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240082AbjJCO3c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 10:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240068AbjJCO3b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 10:29:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B02BAB;
        Tue,  3 Oct 2023 07:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xIGxL70IAJ0M6y011SBk7aa8UdKcrkw0haLaH0GpwLE=; b=II0yd+T26KosygIg1tjTQKllDw
        XYW0lyHa6X25Cz93Tw2eTvmWiuFTLzy3jO5kVra2HO2glpnoSqy5Vwd+5Rm+HURPf0hT8/asFIn5r
        W3JqzaBQ2kUtUNiIiCVil5CvvFNOR/eIEQkksUlF5Weho5UJncQ8Do4sfbrBjLaIsDZmBlyXZlBGw
        R6T9DOj5iEdQuvyykbuwsPWpo+nIzz8uUX40kkRWWMQwB+cF35tMXREaztomTV8CeMWxVozlclaua
        jFGXbyhMKD+73TW/usAUzo4vKt8GC3hppybU9oUEDks2O4rx4iJ+xiec+Tip1ufd7EoIZQUd0GX//
        W3oaB31A==;
Received: from [2001:8b0:10b:5:7381:577e:1952:668f] (helo=u3832b3a9db3152.ant.amazon.com)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qngOk-00FTuD-JK; Tue, 03 Oct 2023 14:29:18 +0000
Message-ID: <96ceb6a6e9c380d329e8cd556ad13a2fcd554882.camel@infradead.org>
Subject: Re: [PATCH RFC 1/1] KVM: x86: add param to update master clock
 periodically
From:   David Woodhouse <dwmw2@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Dongli Zhang <dongli.zhang@oracle.com>,
        Joe Jin <joe.jin@oracle.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com
Date:   Tue, 03 Oct 2023 15:29:18 +0100
In-Reply-To: <ZRtl94_rIif3GRpu@google.com>
References: <20230926230649.67852-1-dongli.zhang@oracle.com>
         <377d9706-cc10-dfb8-5326-96c83c47338d@oracle.com>
         <36f3dbb1-61d7-e90a-02cf-9f151a1a3d35@oracle.com>
         <ZRWnVDMKNezAzr2m@google.com>
         <a461bf3f-c17e-9c3f-56aa-726225e8391d@oracle.com>
         <884aa233ef46d5209b2d1c92ce992f50a76bd656.camel@infradead.org>
         <ZRrxtagy7vJO5tgU@google.com>
         <52a3cea2084482fc67e35a0bf37453f84dcd6297.camel@infradead.org>
         <ZRtl94_rIif3GRpu@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-Xcj+UFkOcF4dEj2yrqD2"
User-Agent: Evolution 3.44.4-0ubuntu2 
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


--=-Xcj+UFkOcF4dEj2yrqD2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2023-10-02 at 17:53 -0700, Sean Christopherson wrote:
>=20
> This is *very* lightly tested, as in it compiles and doesn't explode, but=
 that's
> about all I've tested.

I don't think it's working, if I understand what it's supposed to be
doing.

I hacked my wallclock patch *not* to use
kvm_get_walltime_and_clockread(), but instead use
kvm_get_time_and_clockread() so it should be able to compare
monotonic_raw with kvmclock time. It looks like this.

uint64_t kvm_get_wall_clock_epoch(struct kvm *kvm)
{
	/*
	 * The guest calculates current wall clock time by adding
	 * system time (updated by kvm_guest_time_update below) to the
	 * wall clock specified here.  We do the reverse here.
	 */
#ifdef CONFIG_X86_64
	struct pvclock_vcpu_time_info hv_clock;
	struct kvm_arch *ka =3D &kvm->arch;
	unsigned long seq, local_tsc_khz =3D 0;
	struct timespec64 ts;
	uint64_t host_tsc;

	do {
		seq =3D read_seqcount_begin(&ka->pvclock_sc);

		if (!ka->use_master_clock)
			break;

		/* It all has to happen on the same CPU */
		get_cpu();

		local_tsc_khz =3D get_cpu_tsc_khz();

		if (local_tsc_khz &&
		    !kvm_get_time_and_clockread(&ts.tv_sec, &host_tsc))
			local_tsc_khz =3D 0; /* Fall back to old method */

		hv_clock.tsc_timestamp =3D ka->master_cycle_now;
		hv_clock.system_time =3D ka->master_kernel_ns + ka->kvmclock_offset;

		put_cpu();
	} while (read_seqcount_retry(&ka->pvclock_sc, seq));

	/*
	 * If the conditions were right, and obtaining the wallclock+TSC was
	 * successful, calculate the KVM clock at the corresponding time and
	 * subtract one from the other to get the epoch in nanoseconds.
	 */
	if (local_tsc_khz) {
		kvm_get_time_scale(NSEC_PER_SEC, local_tsc_khz * 1000LL,
				   &hv_clock.tsc_shift,
				   &hv_clock.tsc_to_system_mul);

		uint64_t res =3D __pvclock_read_cycles(&hv_clock, host_tsc);
		uint64_t d2 =3D ts.tv_sec + ka->kvmclock_offset;
		printk("Calculated %lld (%lld/%lld delta %lld, ns %lld o %lld)\n",
		       res,
		       ts.tv_sec, d2, d2-res,
		       ka->master_kernel_ns, ka->kvmclock_offset);
		if (0)
		return ts.tv_nsec + NSEC_PER_SEC * ts.tv_sec -
			__pvclock_read_cycles(&hv_clock, host_tsc);
	}
#endif
	return ktime_get_real_ns() - get_kvmclock_ns(kvm);
}

I also removed the kvm_make_all_cpus_request(kvm,
KVM_REQ_MASTERCLOCK_UPDATE) from kvm_xen_shared_info_init(). I don't
even know why that's there at all, let alone on *all* vCPUs. So now KVM
doesn't keep clamping the kvmclock back to monotonic_raw.

When I run xen_shinfo_test, the kvmclock still drifts from the
"monotonic_raw" I get from kvm_get_time_and_clockread(), even with your
patch.

[98513.851371] Calculated 522601895 (98513572796678/522601913 delta 18, ns =
98513057857491 o -98513050194765)
[98513.851388] Calculated 522619091 (98513572813874/522619109 delta 18, ns =
98513057857491 o -98513050194765)
[98513.851394] Calculated 522625423 (98513572820206/522625441 delta 18, ns =
98513057857491 o -98513050194765)
[98513.851401] Calculated 522631389 (98513572826172/522631407 delta 18, ns =
98513057857491 o -98513050194765)
[98513.851406] Calculated 522636947 (98513572831730/522636965 delta 18, ns =
98513057857491 o -98513050194765)
[98513.851412] Calculated 522643004 (98513572837787/522643022 delta 18, ns =
98513057857491 o -98513050194765)
[98513.851417] Calculated 522648344 (98513572843127/522648362 delta 18, ns =
98513057857491 o -98513050194765)
[98513.851423] Calculated 522654367 (98513572849150/522654385 delta 18, ns =
98513057857491 o -98513050194765)
...
[98517.386027] Calculated 4057257718 (98517107452615/4057257850 delta 132, =
ns 98513057857491 o -98513050194765)
[98517.386030] Calculated 4057261038 (98517107455934/4057261169 delta 131, =
ns 98513057857491 o -98513050194765)
[98517.386034] Calculated 4057265133 (98517107460029/4057265264 delta 131, =
ns 98513057857491 o -98513050194765)
[98517.386037] Calculated 4057268310 (98517107463206/4057268441 delta 131, =
ns 98513057857491 o -98513050194765)
[98517.386040] Calculated 4057271463 (98517107466359/4057271594 delta 131, =
ns 98513057857491 o -98513050194765)
[98517.386044] Calculated 4057274508 (98517107469404/4057274639 delta 131, =
ns 98513057857491 o -98513050194765)
[98517.386048] Calculated 4057278587 (98517107473483/4057278718 delta 131, =
ns 98513057857491 o -98513050194765)
[98517.386051] Calculated 4057281674 (98517107476570/4057281805 delta 131, =
ns 98513057857491 o -98513050194765)
[98517.386057] Calculated 4057288187 (98517107483083/4057288318 delta 131, =
ns 98513057857491 o -98513050194765)
[98517.386064] Calculated 4057294557 (98517107489453/4057294688 delta 131, =
ns 98513057857491 o -98513050194765)


--=-Xcj+UFkOcF4dEj2yrqD2
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjMxMDAzMTQyOTE4WjAvBgkqhkiG9w0BCQQxIgQgoJ5mIYUK
ful8SjtWhx1NfwSlqa/O/Qriga1ZINP6YLEwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgAr3aZJj0rGopZh749ej3hzh0E64VeCGgPk
gSnJsu3evSfUf5UjwzwfL0s5ev3S9tTYoghMutr+h+iYwCezuyE6o5QMOL+UtT+ZiZPUjDHL3zrb
C6DJhc22XY4cPOIrfGT4Q8YaNNzHNy07X5A53YWj+TimkJsc4pJGQXu9rC95ogN9L+mRRE8TA+8a
8UeT8U0qWybT7KkmSqjTKOA2yZln7n4z6mNUSRYrsotABmb13Uxa/VEatv5ftPpkywKtmfiZJUcO
+B1ZcDrgggjvPaA3p1K3kdyH3zE/5D3+ixL49c8s7zevUZeavHVYeqczLBCohjjXhEgAhR5OzzOT
3YlUEx4hEjIYyPKruJbZhrfFCVBwuyxJqW4AG31HFZxmaD8LfsIcRIu/r2ZoFd2DY8ysnE+6c7zc
Yz+OmwUm6p9juTyGUmIqEx7b5q5GZtfhW/+0TVkkjUyGKCzdvQZHThLyMX/IF1gUwT4MUNqeaMSs
TKQT0RT1e5pUTG2XE9HXcERVovdZkuwwuuePHgd8rS124RNbpm9nazt8RaWT1M1sN6A1J4LCNYZB
g/gKXxcx840OSabzcCex8W5B3Sww0E0FgtFul4ibbYsILM8q4JxclzfiOB5aUra/YQ0MXOiHRgH+
UVik7JIepMYx+U3+eXgQKJACIXc+6pe0jmf1AnAqsQAAAAAAAA==


--=-Xcj+UFkOcF4dEj2yrqD2--
