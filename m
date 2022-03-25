Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50AFD4E7DF5
	for <lists+kvm@lfdr.de>; Sat, 26 Mar 2022 01:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbiCYUFg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 16:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232120AbiCYUFW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 16:05:22 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C47109A62
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 12:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ytp398qXwjaJTWVZEOw+bWOowwSzyywbZTN0VPguK8o=; b=VOtn/ZPEr4RE2GLSGn9Wvjf9dn
        YGirK+cxLLE+17PG0L/WmSOGhEoIC3rrDqmYteI0GHpw4BmdtgDpOOchR7n4bdAK2Nf9nJtESq7QA
        BrBQ7UAHeSGIXP8uRkputVBvG3tPiSxsdCMjagZI5lWmUbHCu2T4riTAlOJ1o/e2wTehXqUPMxYpx
        GiQqbDCU8FdyL0ZhrAkmTudxQbBTrk3TbkzWsV1+1Nzx9/uACskJAM3YNNw2CZmh2RWreO+WXFAGG
        LJs00n7c7Tut9ZVfTyV//gH3sdG8X4gkobnveOkFb2c8ia3ZBP3tDV6pdk86GzQuZcoeJ/2QO70dA
        +s4qs8gQ==;
Received: from [2001:8b0:10b:1:4a2a:e3ff:fe14:8625] (helo=u3832b3a9db3152.ant.amazon.com)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nXq47-004VXs-JA; Fri, 25 Mar 2022 19:57:43 +0000
Message-ID: <2a429106053983f4ba7a6226fd5329ce3120907a.camel@infradead.org>
Subject: Re: [PATCH v3 00/17] KVM: Add Xen event channel acceleration
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Metin Kaya <metikaya@amazon.co.uk>,
        Paul Durrant <pdurrant@amazon.co.uk>
Date:   Fri, 25 Mar 2022 19:57:41 +0000
In-Reply-To: <820368fe-690f-8294-736b-52ddea863fa5@redhat.com>
References: <20220303154127.202856-1-dwmw2@infradead.org>
         <820368fe-690f-8294-736b-52ddea863fa5@redhat.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-SS5N+5IvNHm85180vG2T"
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


--=-SS5N+5IvNHm85180vG2T
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2022-03-25 at 19:19 +0100, Paolo Bonzini wrote:
> On 3/3/22 16:41, David Woodhouse wrote:
> > This series adds event channel acceleration for Xen guests. In particul=
ar
> > it allows guest vCPUs to send each other IPIs without having to bounce
> > all the way out to the userspace VMM in order to do so. Likewise, the
> > Xen singleshot timer is added, and a version of SCHEDOP_poll. Those
> > major features are based on Joao and Boris' patches from 2019.
> >=20
> > Cleaning up the event delivery into the vcpu_info involved using the ne=
w
> > gfn_to_pfn_cache for that, and that means I ended up doing so for *all*
> > the places the guest can have a pvclock.
> >=20
> > v0: Proof-of-concept RFC
> >=20
> > v1:
> >   =E2=80=A2 Drop the runstate fix which is merged now.
> >   =E2=80=A2 Add Sean's gfn_to_pfn_cache API change at the start of the =
series.
> >   =E2=80=A2 Add KVM self tests
> >   =E2=80=A2 Minor bug fixes
> >=20
> > v2:
> >   =E2=80=A2 Drop dirty handling from gfn_to_pfn_cache
> >   =E2=80=A2 Fix !CONFIG_KVM_XEN build and duplicate call to kvm_xen_ini=
t_vcpu()
> >=20
> > v3:
> >   =E2=80=A2 Add KVM_XEN_EVTCHN_RESET to clear all outbound ports.
> >   =E2=80=A2 Clean up a stray #if	1 in a part of the the test case that =
was once
> >     being recalcitrant.
> >   =E2=80=A2 Check kvm_xen_has_pending_events() in kvm_vcpu_has_events()=
 and *not*
> >     kvm_xen_has_pending_timer() which is checked from elsewhere.
> >   =E2=80=A2 Fix warnings noted by the kernel test robot <
> > lkp@intel.com
> > >:
> >      =E2=80=A2 Make kvm_xen_init_timer() static.
> >      =E2=80=A2 Make timer delta calculation use an explicit s64 to fix =
32-bit build.
>=20
> I've seen this:
>=20
> [1790637.031490] BUG: Bad page state in process qemu-kvm  pfn:03401
> [1790637.037503] page:0000000077fc41af refcount:0 mapcount:1=20
> mapping:0000000000000000 index:0x7f4ab7e01 pfn:0x3401
> [1790637.047592] head:0000000032101bf5 order:9 compound_mapcount:1=20
> compound_pincount:0
> [1790637.055250] anon flags:=20
> 0xfffffc009000e(referenced|uptodate|dirty|head|swapbacked|node=3D0|zone=
=3D1|lastcpupid=3D0x1fffff)
> [1790637.065949] raw: 000fffffc0000000 ffffda4b800d0001 0000000000000903=
=20
> dead000000000200
> [1790637.073869] raw: 0000000000000100 0000000000000000 00000000ffffffff=
=20
> 0000000000000000
> [1790637.081791] head: 000fffffc009000e dead000000000100=20
> dead000000000122 ffffa0636279fb01
> [1790637.089797] head: 00000007f4ab7e00 0000000000000000=20
> 00000000ffffffff 0000000000000000
> [1790637.097795] page dumped because: nonzero compound_mapcount
> [1790637.103455] Modules linked in: kvm_intel(OE) kvm(OE) overlay tun=20
> tls ib_core rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd=20
> grace fscache netfs rfkill sunrpc intel_rapl_msr intel_rapl_common=20
> isst_if_common skx_edac nfit libnvdimm x86_pkg_temp_thermal=20
> intel_powerclamp coretemp ipmi_ssif iTCO_wdt intel_pmc_bxt irqbypass=20
> iTCO_vendor_support acpi_ipmi rapl dell_smbios ipmi_si mei_me=20
> intel_cstate dcdbas ipmi_devintf i2c_i801 intel_uncore=20
> dell_wmi_descriptor wmi_bmof mei lpc_ich intel_pch_thermal i2c_smbus=20
> ipmi_msghandler acpi_power_meter xfs crct10dif_pclmul i40e crc32_pclmul=
=20
> crc32c_intel megaraid_sas ghash_clmulni_intel tg3 mgag200 wmi fuse [last=
=20
> unloaded: kvm]
> [1790637.162636] CPU: 12 PID: 3056318 Comm: qemu-kvm Kdump: loaded=20
> Tainted: G        W IOE    --------- ---  5.16.0-0.rc6.41.fc36.x86_64 #1
> [1790637.174878] Hardware name: Dell Inc. PowerEdge R440/08CYF7, BIOS=20
> 1.6.11 11/20/2018
> [1790637.182618] Call Trace:
> [1790637.185246]  <TASK>
> [1790637.187524]  dump_stack_lvl+0x48/0x5e
> [1790637.191373]  bad_page.cold+0x63/0x94
> [1790637.195123]  free_tail_pages_check+0xbb/0x110
> [1790637.199656]  free_pcp_prepare+0x270/0x310
> [1790637.203843]  free_unref_page+0x1d/0x120
> [1790637.207856]  kvm_gfn_to_pfn_cache_refresh+0x2c2/0x400 [kvm]
> [1790637.213662]  kvm_setup_guest_pvclock+0x4b/0x180 [kvm]
> [1790637.218913]  kvm_guest_time_update+0x26d/0x330 [kvm]
> [1790637.224080]  vcpu_enter_guest+0x31c/0x1390 [kvm]
> [1790637.228908]  kvm_arch_vcpu_ioctl_run+0x132/0x830 [kvm]
> [1790637.234254]  kvm_vcpu_ioctl+0x270/0x680 [kvm]
>=20
> followed by other badness with the same call stack:
>=20
> [1790637.376127] page dumped because:=20
> VM_BUG_ON_PAGE(page_ref_count(page) =3D=3D 0)
>=20
> I am absolutely not sure that this series is the culprit in any way, but=
=20
> anyway I'll try to reproduce (it happened at the end of a RHEL7.2=20
> installation) and let you know.  If not, it is something that already=20
> made its way to Linus.
>=20

Hrm.... could it be a double/multiple free? This will come from
__release_gpc() which is called from the end of
kvm_gfn_to_pfn_cache_refresh() and which releases the *old* PFN.

How could we get there without... oh... could it be this?

--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -176,6 +176,7 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struc=
t gfn_to_pfn_cache *gpc,
                gpc->uhva =3D gfn_to_hva_memslot(gpc->memslot, gfn);
=20
                if (kvm_is_error_hva(gpc->uhva)) {
+                       gpc->pfn =3D KVM_PFN_ERR_FAULT;
                        ret =3D -EFAULT;
                        goto out;
                }


--=-SS5N+5IvNHm85180vG2T
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjIwMzI1MTk1NzQxWjAvBgkqhkiG9w0BCQQxIgQgWEI06lEX
d6isJWdbTJK908nRqqeV5UATAbssY16wdbMwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgBmdyTWC/Q/uT3nrf8NhP+zT8VRexxOhM3W
PuCtr4S/2jwGuhkSbw3GSb5qUIOLDwdYrUONoo8xDLXiGyZfKusPr1etDVuvG4Qz9NZl3XOXvTxD
avQ491sWJ0IYp4nWoSLx0R1ooha591odW6ovmRmZFR/4KhIrXlp5cXVCBxXZydkoPBcJMccOxEWe
XP9LoczTR5jLswsY3CQntk8oMFgMO0lyK2gKijV+ggUjVYXU5OJrWzB57MyRUk5FP+6banwqVekc
lhMMZ2V0IoDzvBRpC5mU1D7qX0t9yVMMwRKN/sSN4PdkEzCuHqYYFt3ZGoYqWQV14OdtJzdPy3Kf
oXBszyL3GuoDRb1nxucCVfI15MXsY8ajovlXEiyicK8mM+oHHos9TYa7CKoy2qf+0kiKRQRkHMX8
eKvyZfwo4yQpq1NDQqpM9M5BgGcxgV3uMcuUKTaSaFuDCJ6n5n3BKu1o1W+J7IjwnM+87j4/o121
64K5rpYYzF3zByQfYEhioT9EahMrvBNJGB/ItdSIOujlB+XMkEOo6dCw5hCB79Y8JOom7seqzC2I
nqR64R6rCYMX/rhr4KqpzuE5ny0me2u8YQ4V1GYA3MYnjtCltI++DF+EJGguAj8f1BABpo+9Z7zt
/fsERgcFy5oPn1CspVaR9tL8NgwcMJrUoYo8W0j7GgAAAAAAAA==


--=-SS5N+5IvNHm85180vG2T--

