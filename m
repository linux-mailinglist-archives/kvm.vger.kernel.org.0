Return-Path: <kvm+bounces-60048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C21F3BDBF20
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 02:59:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4E44235202B
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 00:59:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BDA81F0991;
	Wed, 15 Oct 2025 00:59:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from ssh247.corpemail.net (ssh247.corpemail.net [210.51.61.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802261E376C;
	Wed, 15 Oct 2025 00:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.51.61.247
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760489985; cv=none; b=W4YPoBec14zTOX/vT/sfUVpssVT+8QGWdmrz2K7hbGzLeud9zkKOOCAQ6GkQxYGzoFPuB19Rr9uXzc4ByKaeFslKmC6I68xUczrUxbiortwir56D7A4nY69zoQAPPqcdiGnbYl6Lnh5NyzXeZ0GdR3WyhZYrI16jNYvQ7zM3W+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760489985; c=relaxed/simple;
	bh=EydKLU21XFhnLZjSAD5c9MEnnu2nmRgXt7ZEigdV4zY=;
	h=Date:Subject:From:To:CC:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=hqw8aaN/dPLykUeSBLCVmebTNtcQ6vZzCgoN7J1l1cX8QBH1t68gMBPEntWQ/3EjhaUbiH79GRqfqqL6MNZ5gDToP/P+453AoUyCFBKcoT7p0uyCELkGCVjTq6kF+nyxWANc4PNIH3h7MRSwoyP76h2zqj7Be8LuzvTqMcL+TS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com; spf=pass smtp.mailfrom=inspur.com; arc=none smtp.client-ip=210.51.61.247
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inspur.com
Received: from jtjnmail201620.home.langchao.com
        by ssh247.corpemail.net ((D)) with ASMTP (SSL) id 202510150859353264;
        Wed, 15 Oct 2025 08:59:35 +0800
Received: from jtjnmailAR02.home.langchao.com (10.100.2.43) by
 jtjnmail201620.home.langchao.com (10.100.2.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Wed, 15 Oct 2025 08:59:34 +0800
Received: from inspur.com (10.100.2.112) by jtjnmailAR02.home.langchao.com
 (10.100.2.43) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Wed, 15 Oct 2025 08:59:34 +0800
Received: from chuguangqing$inspur.com ( [120.224.42.187] ) by
 ajax-webmail-app8 (Coremail) ; Wed, 15 Oct 2025 08:59:33 +0800 (GMT+08:00)
Date: Wed, 15 Oct 2025 08:59:33 +0800
Subject: Re: Re: [PATCH v2 1/1] samples/bpf: Fix spelling typo in
 samples/bpf
From: =?UTF-8?Q?Gary_Chu=28=E6=A5=9A=E5=85=89=E5=BA=86=29?=
	<chuguangqing@inspur.com>
To: Alex Williamson <alex@shazbot.org>
CC: ast <ast@kernel.org>, daniel <daniel@iogearbox.net>, andrii
	<andrii@kernel.org>, martin.lau <martin.lau@linux.dev>, eddyz87
	<eddyz87@gmail.com>, song <song@kernel.org>, yonghong.song
	<yonghong.song@linux.dev>, john.fastabend <john.fastabend@gmail.com>, kpsingh
	<kpsingh@kernel.org>, sdf <sdf@fomichev.me>, haoluo <haoluo@google.com>,
	jolsa <jolsa@kernel.org>, kwankhede <kwankhede@nvidia.com>, bpf
	<bpf@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, kvm
	<kvm@vger.kernel.org>
Message-ID: <68eef1b8.1.4heY4R8JIaj5heY4@inspur.com>
X-Mailer: Coremail Webmail Server Version 2025.1-cmXT6 build
 20250610(aeb0f7c4) Copyright (c) 2002-2025 www.mailtech.cn
 mispb-39078be8-44f8-459d-aa33-411e3e3b0787-inspur.com
X-CMClient-Version: Coremail cmclient(4.2.0.1062 win64.exe)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Priority: 3
X-Coremail-Locale: zh_CN
X-CM-HeaderCharset: UTF-8
In-Reply-To: <20251014140035.31bd9154@shazbot.org>
References: <3e4b2ac992da27b6aeafed9553a7fa9d15-10-25shazbot.org@g.corp-email.com>
 <20251014140035.31bd9154@shazbot.org>
x-cm-smime: signed,cmsm
x-cm-smime-version: cmsm openssl OpenSSL 3.3.1 4 Jun 2024(gm:GmSSL 3.1.1) v1
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=cmsm; boundary="----=_Part_1_2heY4R8JIaj3heY4_20251015085832=----"
X-CM-TRANSID: cAJkCsDwPNH18e5o2lEDAA--.22230W
X-CM-SenderInfo: 5fkxw35dqj1xlqj6x0hvsx2hhfrp/1tbiAQEQDmjucgsOtQABsb
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=
X-CM-DELIVERINFO: =?B?LZuWxJRRTeOiUs3aOqHZ50hzsfHKF9Ds6CbXmDm38RucXu3D1QS02c2pkXQFDIGuCv
	ry86HMgQybAZEbGh79RY5XKDXrZQ3t98cS/hcTFz/6PABjKWMLTbK1W6MAsDVb3gEImP0o
	Eo8H1pNhUNdG0ms/o/mxzHcdxndHU7fhfz+Rke7A
tUid: 202510150859351e3364c12b2d111d1d2502758b732b38
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com

------=_Part_1_2heY4R8JIaj3heY4_20251015085832=----
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: base64

PkknZCBzdWdnZXN0IHRoaXMgZ28gdGhyb3VnaCBicGYgc2luY2UgaXQgdG91Y2hlcyBtb3Jl
IHRoZXJlLiAgRm9yIG10dHksCj4KPkFja2VkLWJ5OiBBbGV4IFdpbGxpYW1zb24gPGFsZXhA
c2hhemJvdC5vcmc+CkNhbiBJIHVuZGVyc3RhbmQgdGhpcyBhcyBzcGxpdHRpbmcgaW50byB0
d28gc2VwYXJhdGUgdGhyZWFkczogb25lIGZvciBCUEYgYW5kIG9uZSBmb3IgbXR0eT8KCkJl
c3QgcmVnYXJkcwpDaHUgR3VhbmdxaW5n



------=_Part_1_2heY4R8JIaj3heY4_20251015085832=----
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

MIIKdwYJKoZIhvcNAQcCoIIKaDCCCmQCAQExDTALBglghkgBZQMEAgEwCwYJKoZIhvcNAQcB
oIIHvTCCB7kwggahoAMCAQICE34AAkSWdsZNK1EPE5IAAQACRJYwDQYJKoZIhvcNAQELBQAw
WTETMBEGCgmSJomT8ixkARkWA2NvbTEYMBYGCgmSJomT8ixkARkWCGxhbmdjaGFvMRQwEgYK
CZImiZPyLGQBGRYEaG9tZTESMBAGA1UEAxMJSU5TUFVSLUNBMB4XDTI0MDkxMjAyMzIxM1oX
DTI5MDkxMTAyMzIxM1owgbYxEzARBgoJkiaJk/IsZAEZFgNjb20xGDAWBgoJkiaJk/IsZAEZ
FghsYW5nY2hhbzEUMBIGCgmSJomT8ixkARkWBGhvbWUxMzAxBgNVBAsMKua1qua9rueUteWt
kOS/oeaBr+S6p+S4muiCoeS7veaciemZkOWFrOWPuDESMBAGA1UEAwwJ5qWa5YWJ5bqGMSYw
JAYJKoZIhvcNAQkBFhdjaHVndWFuZ3FpbmdAaW5zcHVyLmNvbTCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBAKYDFgmitHYS5YOYSpMY26zG6pgktLXqOlSHGXmq5UZxsjEpQHP1
BY4eeUE7+pgfqN1518yfCL6nHIlkQms6pCy2CbJpFMQLSIlNNt1lDnPqOdGXylYV2F/tk33C
bwMjcL8y8brq/HrnD38lA58kUOjuEQaV38jn0coIfbkC8QScz3uBtbuOdI4jSct+liP9tgCy
KI662Lnt9376q+iLLXvbwmrTbCdWTjMNMJjLqBWikMYTKJhTiYe2S4HxI4zKqrEee3SxA6Qe
Yd+Ku8thY2kWMMwXETx5DYr6jGeTSfVnqmzVGESunLualJFkAfWGLEESKXhtT9Yu1q1Y+7Hb
OPUCAwEAAaOCBBowggQWMAsGA1UdDwQEAwIFoDA9BgkrBgEEAYI3FQcEMDAuBiYrBgEEAYI3
FQiC8qkfhIHXeoapkT2GgPcVg9iPXIFK/YsmgZSnTQIBZAIBYTBEBgkqhkiG9w0BCQ8ENzA1
MA4GCCqGSIb3DQMCAgIAgDAOBggqhkiG9w0DBAICAIAwBwYFKw4DAgcwCgYIKoZIhvcNAwcw
HQYDVR0OBBYEFBEL8h6Bd8FOflxman0I5rRuiXFQMB8GA1UdIwQYMBaAFF5ZA6a0TFhgkU72
HrWlOaYywTVqMIIBDwYDVR0fBIIBBjCCAQIwgf+ggfyggfmGgbpsZGFwOi8vL0NOPUlOU1BV
Ui1DQSxDTj1KVENBMjAxMixDTj1DRFAsQ049UHVibGljJTIwS2V5JTIwU2VydmljZXMsQ049
U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1ob21lLERDPWxhbmdjaGFvLERDPWNvbT9j
ZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0P2Jhc2U/b2JqZWN0Q2xhc3M9Y1JMRGlzdHJpYnV0
aW9uUG9pbnSGOmh0dHA6Ly9KVENBMjAxMi5ob21lLmxhbmdjaGFvLmNvbS9DZXJ0RW5yb2xs
L0lOU1BVUi1DQS5jcmwwggEsBggrBgEFBQcBAQSCAR4wggEaMIGxBggrBgEFBQcwAoaBpGxk
YXA6Ly8vQ049SU5TUFVSLUNBLENOPUFJQSxDTj1QdWJsaWMlMjBLZXklMjBTZXJ2aWNlcyxD
Tj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPWhvbWUsREM9bGFuZ2NoYW8sREM9Y29t
P2NBQ2VydGlmaWNhdGU/YmFzZT9vYmplY3RDbGFzcz1jZXJ0aWZpY2F0aW9uQXV0aG9yaXR5
MGQGCCsGAQUFBzAChlhodHRwOi8vSlRDQTIwMTIuaG9tZS5sYW5nY2hhby5jb20vQ2VydEVu
cm9sbC9KVENBMjAxMi5ob21lLmxhbmdjaGFvLmNvbV9JTlNQVVItQ0EoMSkuY3J0MCkGA1Ud
JQQiMCAGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNwoDBDA1BgkrBgEEAYI3FQoEKDAm
MAoGCCsGAQUFBwMCMAoGCCsGAQUFBwMEMAwGCisGAQQBgjcKAwQwSwYDVR0RBEQwQqAnBgor
BgEEAYI3FAIDoBkMF2NodWd1YW5ncWluZ0BpbnNwdXIuY29tgRdjaHVndWFuZ3FpbmdAaW5z
cHVyLmNvbTBQBgkrBgEEAYI3GQIEQzBBoD8GCisGAQQBgjcZAgGgMQQvUy0xLTUtMjEtMTYw
Njk4MDg0OC03MDY2OTk4MjYtMTgwMTY3NDUzMS01NjA0MDYwDQYJKoZIhvcNAQELBQADggEB
AENGHBz0J97mfrnLF1054QNBs0hM8iO39D4x/QqrMf53ghwe3sc0DxmGs6lhAmIWCMlj146j
j6UAEF9BNZUrcysiIFPN/UwHwxFecspHX4WFmQOP41FB0oNXovWtw75GwImsszbUwaSGoWWl
cIfGXI+35PXxhJdIPRx4nlClDcD783an45PF7Mcvkao9IlPTnUfjeKRkLnEKlkxZp+4HQbLK
suW+/N63gqjvpjiNYMvrUQRqR7FRH1GA9w+FgUeI1/1/fCLd9zUBbQnWyaH7eub0g0j7pfH+
DqAQeYh4FZl84NOuE/oUYyUwwmUtChIBls8Fp2FSeywopNaDLmtPipQxggKAMIICfAIBATBw
MFkxEzARBgoJkiaJk/IsZAEZFgNjb20xGDAWBgoJkiaJk/IsZAEZFghsYW5nY2hhbzEUMBIG
CgmSJomT8ixkARkWBGhvbWUxEjAQBgNVBAMTCUlOU1BVUi1DQQITfgACRJZ2xk0rUQ8TkgAB
AAJEljALBglghkgBZQMEAgGggeQwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG
9w0BCQUxDxcNMjUxMDE1MDA1ODMyWjAvBgkqhkiG9w0BCQQxIgQgK2+zodhE4lQ6qdYyZPjM
2PJJouIx5rtXlt2yqyt5nisweQYJKoZIhvcNAQkPMWwwajALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZI
hvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwDQYJKoZIhvcNAQEBBQAEggEALUWX
z17XMotTqiioDiklnbLohydZ311U3bKtoB/HRATgoGE25N9pcIMLTDO27sxR9qF/Y5uvhOY/
OaDP4ZTRJuh768OhZU484OoUZ8AMQX+do2n9qRb2FNgFEz4TqZKLHfti3pCB957Bkz79nkgH
YRlarov8LzEMmv/w7Vv/OPQ4+SwDZ0+tNH7ehDyDLEB0X5zQaFdFuQXVGMi4apT6wZYrDQV4
gFcz0FtHYJjSIbqFvdotmKMAcKUTSrxUWS2Ox2CkCY7l1HCzBlQwnzTCG/6BmI0zjeW7EOYw
rbMQEuiM5V+6vFJYqOrvmp/FkTgMqaQYc/P7Zrxlj+HouEwxww==

------=_Part_1_2heY4R8JIaj3heY4_20251015085832=------

