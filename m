Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29719220C17
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 13:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729920AbgGOLrN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 07:47:13 -0400
Received: from gecko.sbs.de ([194.138.37.40]:59542 "EHLO gecko.sbs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729402AbgGOLrL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 07:47:11 -0400
X-Greylist: delayed 1114 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Jul 2020 07:47:08 EDT
Received: from mail2.sbs.de (mail2.sbs.de [192.129.41.66])
        by gecko.sbs.de (8.15.2/8.15.2) with ESMTPS id 06FBS9hK008569
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 13:28:09 +0200
Received: from [139.25.68.37] ([139.25.68.37])
        by mail2.sbs.de (8.15.2/8.15.2) with ESMTP id 06FBS8tl031088;
        Wed, 15 Jul 2020 13:28:08 +0200
Subject: Re: Inter-VM device emulation (call on Mon 20th July 2020)
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Nikos Dragazis <ndragazis@arrikto.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Thanos Makatos <thanos.makatos@nutanix.com>,
        "John G. Johnson" <john.g.johnson@oracle.com>,
        Andra-Irina Paraschiv <andraprs@amazon.com>,
        Alexander Graf <graf@amazon.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Maxime Coquelin <maxime.coquelin@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
References: <86d42090-f042-06a1-efba-d46d449df280@arrikto.com>
 <20200715112342.GD18817@stefanha-x1.localdomain>
From:   Jan Kiszka <jan.kiszka@siemens.com>
Message-ID: <deb5788e-c828-6996-025d-333cf2bca7ab@siemens.com>
Date:   Wed, 15 Jul 2020 13:28:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200715112342.GD18817@stefanha-x1.localdomain>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms090409030606020909090000"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms090409030606020909090000
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 15.07.20 13:23, Stefan Hajnoczi wrote:
> Hi,
> Several projects are underway to create an inter-VM device emulation
> interface:
>=20
>  * ivshmem v2
>    https://www.mail-archive.com/qemu-devel@nongnu.org/msg706465.html
>=20
>    A PCI device that provides shared-memory communication between VMs.
>    This device already exists but is limited in its current form. The
>    "v2" project updates IVSHMEM's capabilities and makes it suitable as=

>    a VIRTIO transport.
>=20
>    Jan Kiszka is working on this and has posted specs for review.
>=20
>  * virtio-vhost-user
>    https://www.mail-archive.com/virtio-dev@lists.oasis-open.org/msg0642=
9.html
>=20
>    A VIRTIO device that transports the vhost-user protocol. Allows
>    vhost-user device emulation to be implemented by another VM.
>=20
>    Nikos Dragazis is working on this with QEMU, DPDK, and VIRTIO patche=
s
>    posted.
>=20
>  * VFIO-over-socket
>    https://github.com/tmakatos/qemu/blob/master/docs/devel/vfio-over-so=
cket.rst
>=20
>    Similar to the vhost-user protocol in spirit but for any PCI device.=

>    Uses the Linux VFIO ioctl API as the protocol instead of vhost.
>=20
>    It doesn't have a virtio-vhost-user equivalent yet, but the same
>    approach could be applied to VFIO-over-socket too.
>=20
>    Thanos Makatos and John G. Johnson are working on this. The draft
>    spec is available.
>=20
> Let's have a call to figure out:
>=20
> 1. What is unique about these approaches and how do they overlap?
> 2. Can we focus development and code review efforts to get something
>    merged sooner?
>=20
> Jan and Nikos: do you have time to join on Monday, 20th of July at 15:0=
0
> UTC?
> https://www.timeanddate.com/worldclock/fixedtime.html?iso=3D20200720T15=
00
>=20

Not at that slot, but one hour earlier or later would work for me (so far=
).

Jan

> Video call URL: https://bluejeans.com/240406010
>=20
> It would be nice if Thanos and/or JJ could join the call too. Others
> welcome too (feel free to forward this email)!
>=20
> Stefan
>=20

--=20
Siemens AG, Corporate Technology, CT RDA IOT SES-DE
Corporate Competence Center Embedded Linux


--------------ms090409030606020909090000
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
HMMwggaPMIIEd6ADAgECAhQMIWOkSST/t/zbZ1rNyu5yCMypWjANBgkqhkiG9w0BAQsFADBI
MQswCQYDVQQGEwJCTTEZMBcGA1UEChMQUXVvVmFkaXMgTGltaXRlZDEeMBwGA1UEAxMVUXVv
VmFkaXMgUm9vdCBDQSAzIEczMB4XDTE2MDYwNjE0NDM1OVoXDTMxMDYwNjE0NDM1OVowVDEL
MAkGA1UEBhMCQk0xGTAXBgNVBAoMEFF1b1ZhZGlzIExpbWl0ZWQxKjAoBgNVBAMMIVF1b1Zh
ZGlzIEVudGVycHJpc2UgVHJ1c3QgQ0EgMyBHMzCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCC
AgoCggIBAKDQr9a8kNTqqWTbSb/ABorCqUtKPZOVCnndOfZYMlpGnzwNziaqyM8wjLkcOxT7
xVfOpLqYIMZJs3jPKhNH6mPc8NYTwGTkIAcn65v+3TR5i0Z6ltS9CTYyHQYKGU7BgQcUUqEh
Fs2aAu9gaQcO2Rq6pc6AG11dKYGAULWziUdTdcMesfNN2rOKMGAiJZWuGk8kuoZvRaIUr87u
ox1x1SZSNinHvf8CBgV35d8s08jFW80xP/3AkdLSDR+rQpd4TUDeiSKEyxzdKLqfqDc1TotD
52Hjav1bv2qPWdz6gv/pl7Yb9FbNcrvBRMUzQWz0BE6V2ch5Cd6hG/LoS+sCfF74izNdmun0
T4NUAvjyTp0L4OjOaKsq558QyXQEsQoCbTLkl5BcOL5qJOJmp1WE7kcFBEF7GnVHt1fbCYfR
Kxwykc0KGsb31+7hzwRSHhvhY1kc+S4pX6vEKG1RVQZrPlI0ho1crBv0OsuponO8oz5My8Co
PWb7ZNgbeJcAPLuxg7LH275aU8AGgrINSLZHu9TOEQKsQ+Zi3jTJYaxaL9Q7vhSinOvyCaif
MyswSYNSJZ1LALfq9pUnEnPm8czWqjZCQPn7Xk4pOD3/aFh84uX/dX0bT7XkOCTeAhsVOK68
kmZOW0lUH4hMUxTAZsBo1nR0uDERMFLFYoj5xcX9+OErAgMBAAGjggFjMIIBXzAPBgNVHRMB
Af8EBTADAQH/MEkGA1UdIARCMEAwPgYEVR0gADA2MDQGCCsGAQUFBwIBFihodHRwOi8vd3d3
LnF1b3ZhZGlzZ2xvYmFsLmNvbS9yZXBvc2l0b3J5MHQGCCsGAQUFBwEBBGgwZjAqBggrBgEF
BQcwAYYeaHR0cDovL29jc3AucXVvdmFkaXNnbG9iYWwuY29tMDgGCCsGAQUFBzAChixodHRw
Oi8vdHJ1c3QucXVvdmFkaXNnbG9iYWwuY29tL3F2cmNhM2czLmNydDAOBgNVHQ8BAf8EBAMC
AQYwHwYDVR0jBBgwFoAUxhfQvKjqAkPyGwaZXSuQILnXnOQwOwYDVR0fBDQwMjAwoC6gLIYq
aHR0cDovL2NybC5xdW92YWRpc2dsb2JhbC5jb20vcXZyY2EzZzMuY3JsMB0GA1UdDgQWBBTw
FmAimDWJL4b8zdmHHA1jVW06RzANBgkqhkiG9w0BAQsFAAOCAgEAJ3C6bK6r2BE5pdemBIiZ
IvbJ3B5BQnGq9wofNSaVvKGAD5pOnu40wdxzXvatWWyy6rY72lC3wSrYgTbXNhwaK+FESOzd
mhIsezTiBI/yY0HvuLsQyGYeAJiN5vuA199dz1EKyR00INsEWXmG7JsaGacnu3l7VXM9n6w2
NaCY1dxen3Pw1QkGg9mSbd/wLue0mQ33gQdJJyr+Fs5Jwyf2VoMm2i5Ltb4DMP3WvdHipTSD
o9g86dNBorBlFHtLgLUeBUyb8Ik9nVqIud/pPF18u6ivTeRim1lKPjztcKwbawXFgcbiSDcn
4qvDt64sVpmKmjOC1AZX0zYNd5j2YHP8m355ida/zIMMacXFlmZ7QCoThQXJn73n8N4yf40V
LGj9iiJHl5MPMao1COyhxSZx220rW6bI94viPGJmM+NWwOV7eH8O7PPfubtWfYtMkYLglkeU
cSSRnmvw7S8NpaxSATAvxS3DrvBY2RFKQs7yA1nGhT4KTn0l8hBiOBcuE3QK+5seyWo6xHwf
YN9cYKG4j3wwWCwuSXyzgnKuKmHcJ5E57JoyWiws6QNI/ilj/TaLcCS2l32GYOEgnFM12GHE
Esaltl4iH0+sXj1Pido/SdJhpMwCGFK9HLiqnOzD12zkZOu4Rl+nPWGpqhL3oXvGTIe6vgER
WyQsJwMVYpBHCkkwggdHMIIFL6ADAgECAgRISwm+MA0GCSqGSIb3DQEBCwUAMIGeMQswCQYD
VQQGEwJERTEPMA0GA1UECAwGQmF5ZXJuMREwDwYDVQQHDAhNdWVuY2hlbjEQMA4GA1UECgwH
U2llbWVuczERMA8GA1UEBRMIWlpaWlpaQTMxHTAbBgNVBAsMFFNpZW1lbnMgVHJ1c3QgQ2Vu
dGVyMScwJQYDVQQDDB5TaWVtZW5zIElzc3VpbmcgQ0EgRUUgRW5jIDIwMTYwHhcNMTkwMzI1
MDc1MzEyWhcNMjIwMzI1MDc1MzExWjBZMREwDwYDVQQFEwhaMDAyMkVZQjEMMAoGA1UEKgwD
SmFuMQ8wDQYDVQQEDAZLaXN6a2ExEDAOBgNVBAoMB1NpZW1lbnMxEzARBgNVBAMMCktpc3pr
YSBKYW4wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC9Ooae+TRVVXle/gO5QBk4
1qp5kDfCA1ZhT8RyaxNUBzOzbHdycKscEa+Dy/s0Z3h/MwA84u+TwvWqOPdbj628HBrrvKaS
jM6/2ClDc+Ygme4XRuaWOtxhAo5K0U0R/MxVPd2PO2ReP4Auyr80BMe5a4RJyv0+JCtcFVSo
qHOtqvQHThP0ek4tr1G+YzsMz/DJ1WVMf3EpPlXwvYS160fwBvf+We4DJquyzPW0/4DR0eXZ
CS5ZGPRW4gRApKJqA1YTHghkcnLIpNU29w/VdZDh32xm4u99eMjvqn2WuHPRbcgLyV/nDm++
lGtTnEXBEgJQUrAtzUcnjUOxwp+BfcPLAgMBAAGjggLPMIICyzCCAQQGCCsGAQUFBwEBBIH3
MIH0MDIGCCsGAQUFBzAChiZodHRwOi8vYWguc2llbWVucy5jb20vcGtpP1paWlpaWkEzLmNy
dDBBBggrBgEFBQcwAoY1bGRhcDovL2FsLnNpZW1lbnMubmV0L0NOPVpaWlpaWkEzLEw9UEtJ
P2NBQ2VydGlmaWNhdGUwSQYIKwYBBQUHMAKGPWxkYXA6Ly9hbC5zaWVtZW5zLmNvbS9DTj1a
WlpaWlpBMyxvPVRydXN0Y2VudGVyP2NBQ2VydGlmaWNhdGUwMAYIKwYBBQUHMAGGJGh0dHA6
Ly9vY3NwLnBraS1zZXJ2aWNlcy5zaWVtZW5zLmNvbTAfBgNVHSMEGDAWgBShqyxuoHrw08JN
6h/xHiGK/Ayt7zAMBgNVHRMBAf8EAjAAMEUGA1UdIAQ+MDwwOgYNKwYBBAGhaQcCAgMBAzAp
MCcGCCsGAQUFBwIBFhtodHRwOi8vd3d3LnNpZW1lbnMuY29tL3BraS8wgcoGA1UdHwSBwjCB
vzCBvKCBuaCBtoYmaHR0cDovL2NoLnNpZW1lbnMuY29tL3BraT9aWlpaWlpBMy5jcmyGQWxk
YXA6Ly9jbC5zaWVtZW5zLm5ldC9DTj1aWlpaWlpBMyxMPVBLST9jZXJ0aWZpY2F0ZVJldm9j
YXRpb25MaXN0hklsZGFwOi8vY2wuc2llbWVucy5jb20vQ049WlpaWlpaQTMsbz1UcnVzdGNl
bnRlcj9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0MCwGA1UdJQQlMCMGCCsGAQUFBwMEBgor
BgEEAYI3CgMEBgsrBgEEAYI3CgMEATAOBgNVHQ8BAf8EBAMCBDAwIQYDVR0RBBowGIEWamFu
Lmtpc3prYUBzaWVtZW5zLmNvbTAdBgNVHQ4EFgQUPRY49FDDRBWncPRn1OYYRfdRmsUwDQYJ
KoZIhvcNAQELBQADggIBAJhFjrblCswVHUEyoN2QB4I5IOMiglqBTZQt8T/WlKp85/MgcmYb
0YxUg0Ck/zNwuC41PH4Y/YsfMnORFAkk8cqqP8pieHryCX6NJE6RGrnR9wXexVWlZwa+YPIT
MW1PxxD56FDV9PXS6siwJeT/nW2jjAJEaki1DRZneFGFLQxQ2PnelupqIL0ItJwZ79ol0WZn
5Hn4oeFM2WQc+gHmD6/kECDkENKvt8lyn9whrZvURZ3UvL8OBElU43B37wPwE+j7NopPlZW9
rgdgTUiXt5K6YRMcy+l3bMP95hEKE9f3dy37zxvklWhvOOiHLscRZ3ZOUhucOhMyFj4VIGit
SOxLnEiyYMhhZjTb0MCoAZ6WWXhnWzGlgM68fC4T0FakQNnNa3IYIQC0Bqrf+ZDHVGcprKBu
9pnSDFBEb/A3jnTvYefwN1QT+EDNfFm9IzdlbrmSCS1LCglaq4qNzn2iAGe4EW0x3xPh5eNU
3EwntFG4wzgKcZ/A+a26HgrDgIvM3kiwibkef2yERxgdG42g+Wo500OQHiTKPg/rucdaJqOe
A26uxhwzEoI4DTD2n5ECA9xy6TFulczbs05p/hUnwPQsC5VYgLFss3sTxULYFfg1fKdLdobW
1KWJuec1AL2ZW0wR5TIxxNXCDYUafDFHqpmn2WuK/zuS8xrYltKy+PyPMIIHbTCCBVWgAwIB
AgIEAzGvkjANBgkqhkiG9w0BAQsFADCBnzELMAkGA1UEBhMCREUxDzANBgNVBAgMBkJheWVy
bjERMA8GA1UEBwwITXVlbmNoZW4xEDAOBgNVBAoMB1NpZW1lbnMxETAPBgNVBAUTCFpaWlpa
WkEyMR0wGwYDVQQLDBRTaWVtZW5zIFRydXN0IENlbnRlcjEoMCYGA1UEAwwfU2llbWVucyBJ
c3N1aW5nIENBIEVFIEF1dGggMjAxNjAeFw0xOTAzMjUwNzU1MTBaFw0yMjAzMjUwNzUyMjla
MFkxETAPBgNVBAUTCFowMDIyRVlCMQwwCgYDVQQqDANKYW4xDzANBgNVBAQMBktpc3prYTEQ
MA4GA1UECgwHU2llbWVuczETMBEGA1UEAwwKS2lzemthIEphbjCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBAMrY6by3UZvEPp67Bge8nBbh1pzgxudZoV5XNlwfH38QCIfkskAr
TNflXqylMYMDR7QYRxl862nu9ceZWbz2M2snpNm0VBWNTs40HhgsWxTJH6mHLFjrdes2r/3S
yypB6YI6+cnpoHbaIqpbHAs4YVrJ0opLnGp3yUhuQs/mZ8Ixfti4kviDiYKa94TUAriVZVLr
YVO1G8LEMWS19/8U6HUWDX9z5gIDVQdAiQRbcISh76YQVL7gYD4BMe2bl0FZKWaMsczGBP+b
UP+5cdcD8NIX1xJ0L9YX6UusZZ7rPOJftWb7q9ZWOQ9m+KdhTohMKxz7x3YgHkX4G64QQYvJ
27MCAwEAAaOCAvQwggLwMB0GA1UdDgQWBBTzIz81fXJ8N/GMllZ7WqnMZZtmITBJBgNVHREE
QjBAoCYGCisGAQQBgjcUAgOgGAwWamFuLmtpc3prYUBzaWVtZW5zLmNvbYEWamFuLmtpc3pr
YUBzaWVtZW5zLmNvbTAOBgNVHQ8BAf8EBAMCB4AwKQYDVR0lBCIwIAYIKwYBBQUHAwIGCCsG
AQUFBwMEBgorBgEEAYI3FAICMIHKBgNVHR8EgcIwgb8wgbyggbmggbaGJmh0dHA6Ly9jaC5z
aWVtZW5zLmNvbS9wa2k/WlpaWlpaQTIuY3JshkFsZGFwOi8vY2wuc2llbWVucy5uZXQvQ049
WlpaWlpaQTIsTD1QS0k/Y2VydGlmaWNhdGVSZXZvY2F0aW9uTGlzdIZJbGRhcDovL2NsLnNp
ZW1lbnMuY29tL0NOPVpaWlpaWkEyLG89VHJ1c3RjZW50ZXI/Y2VydGlmaWNhdGVSZXZvY2F0
aW9uTGlzdDBFBgNVHSAEPjA8MDoGDSsGAQQBoWkHAgIDAQEwKTAnBggrBgEFBQcCARYbaHR0
cDovL3d3dy5zaWVtZW5zLmNvbS9wa2kvMAwGA1UdEwEB/wQCMAAwHwYDVR0jBBgwFoAUvb0q
QyI9SEpXfpgxF6lwne6fqJkwggEEBggrBgEFBQcBAQSB9zCB9DAyBggrBgEFBQcwAoYmaHR0
cDovL2FoLnNpZW1lbnMuY29tL3BraT9aWlpaWlpBMi5jcnQwQQYIKwYBBQUHMAKGNWxkYXA6
Ly9hbC5zaWVtZW5zLm5ldC9DTj1aWlpaWlpBMixMPVBLST9jQUNlcnRpZmljYXRlMEkGCCsG
AQUFBzAChj1sZGFwOi8vYWwuc2llbWVucy5jb20vQ049WlpaWlpaQTIsbz1UcnVzdGNlbnRl
cj9jQUNlcnRpZmljYXRlMDAGCCsGAQUFBzABhiRodHRwOi8vb2NzcC5wa2ktc2VydmljZXMu
c2llbWVucy5jb20wDQYJKoZIhvcNAQELBQADggIBAJSlh8aYxqSYs6QpE2N4XW2QAuBb1N13
xllhhUnxNmoNH2dXbinS5Wk3Jh937+9IUzE5Xt+vWmvoniLPm9vcJ2KB5CYnjzd6s7+H97Wy
QlxFu7c9vaf9WME5pN5E5F1J/P3YyjmdYIdEWppG0NdsmxHXjDbnMyYhsjiPebXUZgut36+H
FkMxpOQugQtM1XnEvQHPPXwxGohlcFjn4VCGaBQft3KIdptdRisfsyH1BZXOfRF4RzzG3kq5
j0f4dyWpq90XzSOjj+Sz/oSxOCPuddCvBo4eiwTrCO3Hto1pXwkxiEG8R9Tfqwq8YUSi8is1
SxRIzqQ1d8i2SXF7ejHbvc3zmUYRxToGbJTjGysWtFXhR1xQJUQqWzHWGH9K4/jBDD42CQsO
X+flxcEW8vBe0vqv2502wuJVJ8tZnBTvJpA0KpFsBTzAPR749gS0loySLFKK6FJ6AbYf/sYt
TJJepru+vwY959TdMrSmsmRTihLUYX8KlQtTEPCTSQ1KRvvIa3yTofJJE2gqccB85s/1ZZCN
TlNuiB2zwuz5Q1D2VP/gmjbH0s8gzdGtI6BuzbP0B0UBiWVjZjEN7W+8Z6ImCIApmD2mzoo2
9W33H1qp6CqPm6/7IRNphlSsh6fo9IjmIz/A1YGlSH3i36S4AjerKeffE3sjTrlrTQ6TTVBC
1eoeMIIHcDCCBVigAwIBAgIUeBQoY8R8ltP8wn3/1poag1LaY20wDQYJKoZIhvcNAQELBQAw
VDELMAkGA1UEBhMCQk0xGTAXBgNVBAoMEFF1b1ZhZGlzIExpbWl0ZWQxKjAoBgNVBAMMIVF1
b1ZhZGlzIEVudGVycHJpc2UgVHJ1c3QgQ0EgMyBHMzAeFw0xNjA4MDQxNTMzMDZaFw0yMjA4
MDQxNTMzMDZaMIGfMQswCQYDVQQGEwJERTEPMA0GA1UECAwGQmF5ZXJuMREwDwYDVQQHDAhN
dWVuY2hlbjEQMA4GA1UECgwHU2llbWVuczERMA8GA1UEBRMIWlpaWlpaQTIxHTAbBgNVBAsM
FFNpZW1lbnMgVHJ1c3QgQ2VudGVyMSgwJgYDVQQDDB9TaWVtZW5zIElzc3VpbmcgQ0EgRUUg
QXV0aCAyMDE2MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAy1aUq88DjZYPge0v
ZnAr3KJHmMi0o5mphy54Xr592Vtf8u/B3TCyD+iGCYANPYUq4sG18qXcVxGadz7zeEm6RI7j
KKl3URAvzFGiYForZE0JKxwo956T/diLLpH1vHEQDbp8AjNK7aGoltZnm/Jn6IVQy9iBY0SE
lRIBhUlppS4/J2PHtKEvQVYJfkAwTtHuGpvPaesoJ8bHA0KhEZ4+/kIYQebaNDf0ltTmXd4Z
8zeUhE25d9MzoFnQUg+F01ewMfc0OsEFheKWP6dmo0MSLWARXxjI3K2RTHtJU5hxjb/+SA2w
lfpqwNIAkTECDBfqYxHReAT8PeezvzEkNZ9RrXl9qj0Cm2iZAjY1SL+asuxrGvFwEW/ZKJ2A
RY/ot1cHh/I79srzh/jFieShVHbT6s6fyKXmkUjBOEnybUKUqcvNuOXnwEiJ/9jKT5UVBWTD
xbEQucAarVNFBEf557o9ievbT+VAZKZ8F4tJge6jl2y19eppflresr7Xui9wekK2LYcLOF3X
/MOCFq/9VyQDyE7X9KNGtEx74V6J2QpbbRJryvavh3b0eQEtqDc65eiEaP8awqOErN8EEYh7
Gdx4Um3QFcm1TBhkZTdQdLlWv4LvIBnXiBEWRczQYEIm5wv5ZkyPwdL39Xwc72esPPBu8FtQ
FVcQlRdGI2t5Ywefq48CAwEAAaOCAewwggHoMIGBBggrBgEFBQcBAQR1MHMwOgYIKwYBBQUH
MAKGLmh0dHA6Ly90cnVzdC5xdW92YWRpc2dsb2JhbC5jb20vcXZlbnRjYTNnMy5jcnQwNQYI
KwYBBQUHMAGGKWh0dHA6Ly9xdmVudGNhM2czLm9jc3AucXVvdmFkaXNnbG9iYWwuY29tMB0G
A1UdDgQWBBS9vSpDIj1ISld+mDEXqXCd7p+omTASBgNVHRMBAf8ECDAGAQH/AgEAMB8GA1Ud
IwQYMBaAFPAWYCKYNYkvhvzN2YccDWNVbTpHMIGJBgNVHSAEgYEwfzBGBgwrBgEEAb5YAAOO
CAAwNjA0BggrBgEFBQcCARYoaHR0cDovL3d3dy5xdW92YWRpc2dsb2JhbC5jb20vcmVwb3Np
dG9yeTA1BggrBgEEAaFpBzApMCcGCCsGAQUFBwIBFhtodHRwOi8vd3d3LnNpZW1lbnMuY29t
L3BraS8wPQYDVR0fBDYwNDAyoDCgLoYsaHR0cDovL2NybC5xdW92YWRpc2dsb2JhbC5jb20v
cXZlbnRjYTNnMy5jcmwwDgYDVR0PAQH/BAQDAgEGMDMGA1UdJQQsMCoGCCsGAQUFBwMCBggr
BgEFBQcDBAYKKwYBBAGCNxQCAgYIKwYBBQUHAwkwDQYJKoZIhvcNAQELBQADggIBAEFpUHKS
11PPt1am8zJRm+eUjZC6ssOPxdkB0qWBtAdKkJ8/keDC2F77cP4hpIl56wSS8n6Z0i+oI8wV
uh4iC4AIM4uQV8zfYIXaVfEc0MV25ymaFtYkl2OnozKVo5J1GsoHcjw30y1E3090rmKIQFBC
4BRRvhJEDUa4V7/4lxCplARsvAofCGsfu9chPdtQ+9Xz9PG++h2lw6K5UVlGoDm4lfwKnQNK
vGYiZ+gXdrxI4IBwHSMS2wCyMWVaETry/iw1DgTUfZYzRKOIHw+gBcnynyfuM4vrAWwH6GQd
4vxnATqftNB5vA4NJnCmkcwqsk8t+qw2jf+yhrPmIoGCMcmjKnq0aoIcHqyCnXqJ5Qd9DAw+
NCGsS5dv3gcwEFGYjazXGWYNPpH87uBtQA035xQqMshcbV3ne6r/G9qya8QEndZUTLTbw6UR
OsGUhKkLpNr4QylLaVnkBbH4ZMtUMKQfS6urxsoZrSQSXYrP6QdRWgGgOO9tQFpR9cwUwFk8
fo1U+iEG0/jP6tk1eOezzVPn8I6uwh14P6ZMeXWF97CgIQUH71NlTkGDnIpjmfkEcTFFyyp9
e3PNmJKP972M+IaItxHcn4Rm1qFg6UmftsCTXWsEj6FIWdVrc8zOZpZv0PB8TTwGs8dT1SKt
XnN/U3wvhj1F545w2dfgt/nNcBxyMYIEJzCCBCMCAQEwgagwgZ8xCzAJBgNVBAYTAkRFMQ8w
DQYDVQQIDAZCYXllcm4xETAPBgNVBAcMCE11ZW5jaGVuMRAwDgYDVQQKDAdTaWVtZW5zMREw
DwYDVQQFEwhaWlpaWlpBMjEdMBsGA1UECwwUU2llbWVucyBUcnVzdCBDZW50ZXIxKDAmBgNV
BAMMH1NpZW1lbnMgSXNzdWluZyBDQSBFRSBBdXRoIDIwMTYCBAMxr5IwDQYJYIZIAWUDBAIB
BQCgggJPMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIwMDcx
NTExMjgwN1owLwYJKoZIhvcNAQkEMSIEILd5+E/kFYAEBpIOkAMNJhcPdn5sU7VNuSIweXyx
WNt5MGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG
9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcN
AwICASgwgbgGCSsGAQQBgjcQBDGBqjCBpzCBnjELMAkGA1UEBhMCREUxDzANBgNVBAgMBkJh
eWVybjERMA8GA1UEBwwITXVlbmNoZW4xEDAOBgNVBAoMB1NpZW1lbnMxETAPBgNVBAUTCFpa
WlpaWkEzMR0wGwYDVQQLDBRTaWVtZW5zIFRydXN0IENlbnRlcjEnMCUGA1UEAwweU2llbWVu
cyBJc3N1aW5nIENBIEVFIEVuYyAyMDE2AgRISwm+MIG6BgsqhkiG9w0BCRACCzGBqqCBpzCB
njELMAkGA1UEBhMCREUxDzANBgNVBAgMBkJheWVybjERMA8GA1UEBwwITXVlbmNoZW4xEDAO
BgNVBAoMB1NpZW1lbnMxETAPBgNVBAUTCFpaWlpaWkEzMR0wGwYDVQQLDBRTaWVtZW5zIFRy
dXN0IENlbnRlcjEnMCUGA1UEAwweU2llbWVucyBJc3N1aW5nIENBIEVFIEVuYyAyMDE2AgRI
Swm+MA0GCSqGSIb3DQEBAQUABIIBAHMGdGuB1JFQEJBhcEi4JKIqgy10sOUvbzbARWQSFfvf
rszoxSgb5WcayKu1HuemgeZkyXOp5bLeXmdQH6Mxtz5o/vqGaYjckS1sDrvvQ0WFq+JVxl7b
9RYGEFgCYHmd2waFS0iG9jE0W67sr38KsAPsWaJMn08l3cdiyylQsat+kNJQc9f97dECZF+L
8voWyIBUjK94G6mH37YegJGtIH/T9uPMjwk0kSovVCYS7bucibZAhLzybLiBsEl/1lmCPIbG
4ADe2+DeBj9r8VEB0h4JrAHM2rzEusJ0jft6yy0SJgBBZw3csm5OY8VP4qv/A/9x+DeapPEk
BJs9nsDaiq0AAAAAAAA=
--------------ms090409030606020909090000--
