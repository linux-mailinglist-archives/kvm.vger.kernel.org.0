Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966577D9724
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 14:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345688AbjJ0MDV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 08:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345539AbjJ0MDU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 08:03:20 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E76C0
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 05:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xbyOrQ9050h9MAoHON7t0yBFDvlRtikljfzvgpDlS5Q=; b=p+g4Ef6ShSjHTgCd2R9gQAyDRQ
        JQvbiCt5jRM9oiI9mj42/ecATMUQnKbnY22xn+4EqIIt62sscqJWQhUJ/+yDvB/NeJoNEG7PZ7d0o
        QfRwS9hT0Zuv20ex9C2a7TZIZNmPvjWqGFTjzF3VHVQArBgJYuuuFkFSUFSE7tab5IViq3ME0jIqc
        O63DeZXRCnJiUcMEnN6r9N80+U/snK/fnlTE1hCaOSwgDo0TGNXxKw8KwwXyH8tkJxM9hzinF/5D1
        eB8cOk1QzGbWQ4pAmiSegyR411z/LTRYTeR72mzaiVLL2WrJdLKF91zQyDL99ddRNd5vDMEfub8Mp
        vwxwvaow==;
Received: from [2001:8b0:10b:5:a059:f7a9:933a:2236] (helo=u3832b3a9db3152.ant.amazon.com)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qwLY8-003HdW-Af; Fri, 27 Oct 2023 12:02:48 +0000
Message-ID: <31acd48a13b3e198a025da1add7d8f7253f262ba.camel@infradead.org>
Subject: Re: [PATCH v3 13/28] hw/xen: automatically assign device index to
 block devices
From:   David Woodhouse <dwmw2@infradead.org>
To:     paul@xen.org, qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        =?ISO-8859-1?Q?Marc-Andr=E9?= Lureau 
        <marcandre.lureau@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Jason Wang <jasowang@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Bernhard Beschow <shentey@gmail.com>,
        Joel Upham <jupham125@gmail.com>
Date:   Fri, 27 Oct 2023 13:02:45 +0100
In-Reply-To: <c538ea45-dac7-49f3-ad50-8c3a59755dee@gmail.com>
References: <20231025145042.627381-1-dwmw2@infradead.org>
         <20231025145042.627381-14-dwmw2@infradead.org>
         <74e54da5-9c35-485d-a13c-efac3f81dec2@gmail.com>
         <f72e2e7feed3ecf17af8ab8442c359eea329ef17.camel@infradead.org>
         <9fb67e52-f262-4cf4-91c2-a42411ba21c4@gmail.com>
         <b6458e730fd861243f534e33a48a857122e77ed5.camel@infradead.org>
         <c538ea45-dac7-49f3-ad50-8c3a59755dee@gmail.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-x8BOGq/ESRm/cDp9nNRD"
User-Agent: Evolution 3.44.4-0ubuntu2 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-x8BOGq/ESRm/cDp9nNRD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2023-10-27 at 11:32 +0100, Durrant, Paul wrote:
> On 27/10/2023 11:25, David Woodhouse wrote:
> > On Fri, 2023-10-27 at 10:01 +0100, Durrant, Paul wrote:
> > >=20
> > > This code is allocating a name automatically so I think the onus is o=
n
> > > it not create a needless clash which is likely to have unpredictable
> > > results depending on what the guest is. Just avoid any aliasing in th=
e
> > > first place and things will be fine.
> >=20
> >=20
> > Yeah, fair enough. In which case I'll probably switch to using
> > xs_directory() and then processing those results to find a free slot,
> > instead of going out to XenStore for every existence check.
> >=20
> > This isn't exactly fast path and I'm prepared to tolerate a little bit
> > of O(n=C2=B2), but only within reason :)
>=20
> Yes, doing an xs_directory() and then using the code=20
> xen_block_get_vdev() to populate a list of existent disks will be neater.

diff --git a/hw/block/xen-block.c b/hw/block/xen-block.c
index 5011fe9430..9b7d7ef7e1 100644
--- a/hw/block/xen-block.c
+++ b/hw/block/xen-block.c
@@ -30,48 +30,105 @@
 #include "hw/xen/interface/io/xs_wire.h"
 #include "trace.h"
=20
-static char *xen_block_get_name(XenDevice *xendev, Error **errp)
+#define XVDA_MAJOR 202
+#define XVDQ_MAJOR (1<<20)
+#define XVDBGQCV_MAJOR ((1<<21) - 1)
+#define HDA_MAJOR 3
+#define HDC_MAJOR 22
+#define SDA_MAJOR 8
+
+/*
+ * This is fairly arbitrary just to avoid a stupidly sized bitmap, but Lin=
ux
+ * as of v6.6 only supports up to /dev/xvdfan (disk 4095) anyway.
+ */
+#define MAX_AUTO_VDEV 4096
+
+static int vdev_to_diskno(unsigned int vdev_nr)
 {
-    XenBlockDevice *blockdev =3D XEN_BLOCK_DEVICE(xendev);
+    switch (vdev_nr >> 8) {
+    case XVDA_MAJOR:
+    case SDA_MAJOR:
+        return (vdev_nr >> 4) & 0x15;
+
+    case HDA_MAJOR:
+        return (vdev_nr >> 6) & 1;
+
+    case HDC_MAJOR:
+        return ((vdev_nr >> 6) & 1) + 2;
+
+    case XVDQ_MAJOR ... XVDBGQCV_MAJOR:
+        return (vdev_nr >> 8) & 0xfffff;
+
+    default:
+        return -1;
+    }
+}
+
+static bool xen_block_find_free_vdev(XenBlockDevice *blockdev, Error **err=
p)
+{
+    XenBus *xenbus =3D XEN_BUS(qdev_get_parent_bus(DEVICE(blockdev)));
+    unsigned long used_devs[BITS_TO_LONGS(MAX_AUTO_VDEV)];
     XenBlockVdev *vdev =3D &blockdev->props.vdev;
+    char fe_path[XENSTORE_ABS_PATH_MAX + 1];
+    char **existing_frontends;
+    unsigned int nr_existing =3D 0;
+    unsigned int vdev_nr;
+    int i, disk =3D 0;
+
+    snprintf(fe_path, sizeof(fe_path), "/local/domain/%u/device/vbd",
+             blockdev->xendev.frontend_id);
+
+    existing_frontends =3D qemu_xen_xs_directory(xenbus->xsh, XBT_NULL, fe=
_path,
+                                               &nr_existing);
+    if (!existing_frontends && errno !=3D ENOENT) {
+        error_setg_errno(errp, errno, "cannot read %s", fe_path);
+        return false;
+    }
=20
-    if (blockdev->props.vdev.type =3D=3D XEN_BLOCK_VDEV_TYPE_INVALID) {
-        XenBus *xenbus =3D XEN_BUS(qdev_get_parent_bus(DEVICE(xendev)));
-        char fe_path[XENSTORE_ABS_PATH_MAX + 1];
-        char *value;
-        int disk =3D 0;
-        unsigned long idx;
-
-        /* Find an unoccupied device name */
-        while (disk < (1 << 20)) {
-            if (disk < (1 << 4)) {
-                idx =3D (202 << 8) | (disk << 4);
-            } else {
-                idx =3D (1 << 28) | (disk << 8);
-            }
-            snprintf(fe_path, sizeof(fe_path),
-                     "/local/domain/%u/device/vbd/%lu",
-                     xendev->frontend_id, idx);
-            value =3D qemu_xen_xs_read(xenbus->xsh, XBT_NULL, fe_path, NUL=
L);
-            if (!value) {
-                if (errno =3D=3D ENOENT) {
-                    vdev->type =3D XEN_BLOCK_VDEV_TYPE_XVD;
-                    vdev->partition =3D 0;
-                    vdev->disk =3D disk;
-                    vdev->number =3D idx;
-                    goto found;
-                }
-                error_setg(errp, "cannot read %s: %s", fe_path,
-                           strerror(errno));
-                return NULL;
-            }
-            free(value);
-            disk++;
+    memset(used_devs, 0, sizeof(used_devs));
+    for (i =3D 0; i < nr_existing; i++) {
+        if (qemu_strtoui(existing_frontends[i], NULL, 10, &vdev_nr)) {
+            free(existing_frontends[i]);
+            continue;
         }
+
+        free(existing_frontends[i]);
+
+        disk =3D vdev_to_diskno(vdev_nr);
+        if (disk < 0 || disk >=3D MAX_AUTO_VDEV) {
+            continue;
+        }
+
+        set_bit(disk, used_devs);
+    }
+    free(existing_frontends);
+
+    disk =3D find_first_zero_bit(used_devs, MAX_AUTO_VDEV);
+    if (disk =3D=3D MAX_AUTO_VDEV) {
         error_setg(errp, "cannot find device vdev for block device");
+        return false;
+    }
+
+    vdev->type =3D XEN_BLOCK_VDEV_TYPE_XVD;
+    vdev->partition =3D 0;
+    vdev->disk =3D disk;
+    if (disk < (1 << 4)) {
+        vdev->number =3D (XVDA_MAJOR << 8) | (disk << 4);
+    } else {
+        vdev->number =3D (XVDQ_MAJOR << 8) | (disk << 8);
+    }
+    return true;
+}
+
+static char *xen_block_get_name(XenDevice *xendev, Error **errp)
+{
+    XenBlockDevice *blockdev =3D XEN_BLOCK_DEVICE(xendev);
+    XenBlockVdev *vdev =3D &blockdev->props.vdev;
+
+    if (vdev->type =3D=3D XEN_BLOCK_VDEV_TYPE_INVALID &&
+        !xen_block_find_free_vdev(blockdev, errp)) {
         return NULL;
     }
- found:
     return g_strdup_printf("%lu", vdev->number);
 }
=20
@@ -520,10 +577,10 @@ static void xen_block_set_vdev(Object *obj, Visitor *=
v, const char *name,
     case XEN_BLOCK_VDEV_TYPE_DP:
     case XEN_BLOCK_VDEV_TYPE_XVD:
         if (vdev->disk < (1 << 4) && vdev->partition < (1 << 4)) {
-            vdev->number =3D (202 << 8) | (vdev->disk << 4) |
+            vdev->number =3D (XVDA_MAJOR << 8) | (vdev->disk << 4) |
                 vdev->partition;
         } else if (vdev->disk < (1 << 20) && vdev->partition < (1 << 8)) {
-            vdev->number =3D (1 << 28) | (vdev->disk << 8) |
+            vdev->number =3D (XVDQ_MAJOR << 8) | (vdev->disk << 8) |
                 vdev->partition;
         } else {
             goto invalid;
@@ -533,10 +590,10 @@ static void xen_block_set_vdev(Object *obj, Visitor *=
v, const char *name,
     case XEN_BLOCK_VDEV_TYPE_HD:
         if ((vdev->disk =3D=3D 0 || vdev->disk =3D=3D 1) &&
             vdev->partition < (1 << 6)) {
-            vdev->number =3D (3 << 8) | (vdev->disk << 6) | vdev->partitio=
n;
+            vdev->number =3D (HDA_MAJOR << 8) | (vdev->disk << 6) | vdev->=
partition;
         } else if ((vdev->disk =3D=3D 2 || vdev->disk =3D=3D 3) &&
                    vdev->partition < (1 << 6)) {
-            vdev->number =3D (22 << 8) | ((vdev->disk - 2) << 6) |
+            vdev->number =3D (HDC_MAJOR << 8) | ((vdev->disk - 2) << 6) |
                 vdev->partition;
         } else {
             goto invalid;
@@ -545,7 +602,7 @@ static void xen_block_set_vdev(Object *obj, Visitor *v,=
 const char *name,
=20
     case XEN_BLOCK_VDEV_TYPE_SD:
         if (vdev->disk < (1 << 4) && vdev->partition < (1 << 4)) {
-            vdev->number =3D (8 << 8) | (vdev->disk << 4) | vdev->partitio=
n;
+            vdev->number =3D (SDA_MAJOR << 8) | (vdev->disk << 4) | vdev->=
partition;
         } else {
             goto invalid;
         }


--=-x8BOGq/ESRm/cDp9nNRD
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjMxMDI3MTIwMjQ1WjAvBgkqhkiG9w0BCQQxIgQgy6jZIEVn
ttaZcN5FM5XBjbNwWd/MX+hlAaS0WhMuzaMwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgCMYXqkqgZsdFMHIMkBhqcvK/8acgkyKqTW
eosVHutNWGf9mmit54r3qRhGCsxZeUex/K6/LeFbgYkw0afPWUsP6+tAQbuBou6UqcHjonpOkJ+0
8ig9NGJ/R8wS6xWrV9xpipflHil78T2Q6uXiCZjXr7gPtIVFI4rdkxW4WNdhCSt0iVstCUMTTqo1
wSc22LnCXhRkjwJUb2XnMTpQbQ8D6sEhx/r+aOplZwhDRltkxnW7bcYBHdhiM7P/rCh1pUHcbqV6
0rAFSL+eSlpTj89hzd/CNNbe17JBwQKZlFj8HWaGocR+F0Vsn3PEkizaDXYFxw5x+gVuQyi4cSiI
D6U/AJuXA2Pv2gou4klFKYbvQQtQCnG811udwUA4MMVZNw2OrMTqex21MzY+hR3LKWd3onNMb9ZN
Ap5a6KKkhBhbK6yhQKjoFSg16HEhHNzOsONze92z0L+P82GyjsRlmXgYrdSErW4CBrwgSh28k5gf
mMakB/GRgGirvgCs/uFv5uXXgeXXcttoq3itZQsf2v/26BneNlMwrdsqSdd5k7jUoRUOTwMVHvw1
eWIB6USIFRbudKhd9nx5dPMpd1i2wx/DKZHdRFVaVuWvsa1vMdtnjhb+lQrKhao0kDpIzn8TIoOs
5uQfwiKt7EItb/Gbx/Uc9HY3uuZheckYX/jsyloYyQAAAAAAAA==


--=-x8BOGq/ESRm/cDp9nNRD--
