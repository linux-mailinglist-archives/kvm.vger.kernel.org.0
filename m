Return-Path: <kvm+bounces-59992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F07E1BD77F7
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 07:53:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6E9B404655
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 05:53:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C92A29BDBB;
	Tue, 14 Oct 2025 05:53:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from unicom146.biz-email.net (unicom146.biz-email.net [210.51.26.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293A729BDB8;
	Tue, 14 Oct 2025 05:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.51.26.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760421191; cv=none; b=qj6Mql2yJx4viHi9nEaIrPSvdmhaRcX6ytv8QK23IIW0Lj9TmHFvvUKC/t7scCorOel7fXpkx5TUJRC/m6u5WIy9vTKn5Zp/4AwwgF804dQb0i+km8yypmur0CNoh3eY/Wo8D2S4hhxzZoD1WPSdSfifaaL2UOE8+Utg1iDEoZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760421191; c=relaxed/simple;
	bh=3G+157xk86k/K+kQZDUYX0P/G7QlPVFuOjaSEJoFp3Y=;
	h=Date:Subject:From:To:CC:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=Xa8xIZFqABjn/VPN7D5Y8ajkkVEbfDT3nmLDdnO8xRNS0pIydp54Ft77C4toAI9UbXIVW4gcetLPN6mOcF0l7WFtWrNiim2gEC4DsjO4NXcpTuLOele5XRd2elfE+3gYyvfayohVax9qB+c+8pANYRaXPKi0dPoh5bnqJXhhJH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com; spf=pass smtp.mailfrom=inspur.com; arc=none smtp.client-ip=210.51.26.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inspur.com
Received: from jtjnmail201608.home.langchao.com
        by unicom146.biz-email.net ((D)) with ASMTP (SSL) id 202510141353001786;
        Tue, 14 Oct 2025 13:53:00 +0800
Received: from jtjnmailAR01.home.langchao.com (10.100.2.42) by
 jtjnmail201608.home.langchao.com (10.100.2.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Tue, 14 Oct 2025 13:53:00 +0800
Received: from inspur.com (10.100.2.96) by jtjnmailAR01.home.langchao.com
 (10.100.2.42) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Tue, 14 Oct 2025 13:53:00 +0800
Received: from chuguangqing$inspur.com ( [10.94.17.151] ) by
 ajax-webmail-app1 (Coremail) ; Tue, 14 Oct 2025 13:53:00 +0800 (GMT+08:00)
Date: Tue, 14 Oct 2025 13:53:00 +0800
Subject: Re: Re: [PATCH 0/5] Some spelling error fixes in samples directory
From: =?UTF-8?Q?Gary_Chu=28=E6=A5=9A=E5=85=89=E5=BA=86=29?=
	<chuguangqing@inspur.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann
	<daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau
	<martin.lau@linux.dev>, Eduard <eddyz87@gmail.com>, Song Liu
	<song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, John Fastabend
	<john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Stanislav Fomichev
	<sdf@fomichev.me>, Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
	kwankhede <kwankhede@nvidia.com>, bpf <bpf@vger.kernel.org>, LKML
	<linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Message-ID: <68ede500.1.I5a5cMEoHajJ5a5c@inspur.com>
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
In-Reply-To: <CAADnVQKMgbDV2poeHYmJg0=GD-F2zDTcjSxcUDZSO3Y5EwD17Q@mail.gmail.com>
References: <906d79e906812eba2cf73fb5e7e6ddba14-10-25gmail.com@g.corp-email.com>
 <CAADnVQKMgbDV2poeHYmJg0=GD-F2zDTcjSxcUDZSO3Y5EwD17Q@mail.gmail.com>
x-cm-smime: signed,cmsm
x-cm-smime-version: cmsm openssl OpenSSL 3.3.1 4 Jun 2024(gm:GmSSL 3.1.1) v1
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=cmsm; boundary="----=_Part_1_G5a5cMEoHajH5a5c_20251014135200=----"
X-CM-TRANSID: YAJkCsDwDXU85e1oD84WAA--.17814W
X-CM-SenderInfo: 5fkxw35dqj1xlqj6x0hvsx2hhfrp/1tbiAQEPDmjtIIspYAABsn
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=
X-CM-DELIVERINFO: =?B?N9pETpRRTeOiUs3aOqHZ50hzsfHKF9Ds6CbXmDm38RucXu3D1QS02c2pkXQFDIGuCv
	ry82gJnDZpQEYdRut3ttFMxxITN1UU1tADN0SVFaZA3YckaxLmYF0I3BebHP3TkeOW9StX
	29SErP86rVbUovyq+ifyKGfRBHF+CSEbK1UHwaZY
tUid: 202510141353005711d2a96d4981f3f38dfd38a1266168
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com

------=_Part_1_G5a5cMEoHajH5a5c_20251014135200=----
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: base64

Pk9uIE1vbiwgT2N0IDEzLCAyMDI1IGF0IDc6MzXigK9QTSBDaHUgR3VhbmdxaW5nIDxjaHVn
dWFuZ3FpbmdAaW5zcHVyLmNvbT4gd3JvdGU6Cj4+Cj4+IEZpeGVzIGZvciBzb21lIHNwZWxs
aW5nIGVycm9ycyBpbiBzYW1wbGVzIGRpcmVjdG9yeQo+Pgo+PiBDaHUgR3VhbmdxaW5nICg1
KToKPj4gICBzYW1wbGVzL2JwZjogRml4IGEgc3BlbGxpbmcgdHlwbyBpbiBkb19oYm1fdGVz
dC5zaAo+PiAgIHNhbXBsZXM6IGJwZjogRml4IGEgc3BlbGxpbmcgdHlwbyBpbiBoYm0uYwo+
PiAgIHNhbXBsZXMvYnBmOiBGaXggYSBzcGVsbGluZyB0eXBvIGluIHRyYWNleDEuYnBmLmMK
Pj4gICBzYW1wbGVzL2JwZjogRml4IGEgc3BlbGxpbmcgdHlwbyBpbiB0Y3BfY29uZ19rZXJu
LmMKPj4gICB2ZmlvLW1kZXY6IEZpeCBhIHNwZWxsaW5nIHR5cG8gaW4gbXR0eS5jCj4+Cj4+
ICBzYW1wbGVzL2JwZi9kb19oYm1fdGVzdC5zaCAgfCAyICstCj4+ICBzYW1wbGVzL2JwZi9o
Ym0uYyAgICAgICAgICAgfCA0ICsrLS0KPj4gIHNhbXBsZXMvYnBmL3RjcF9jb25nX2tlcm4u
YyB8IDIgKy0KPj4gIHNhbXBsZXMvYnBmL3RyYWNleDEuYnBmLmMgICB8IDIgKy0KPj4gIHNh
bXBsZXMvdmZpby1tZGV2L210dHkuYyAgICB8IDIgKy0KPj4gIDUgZmlsZXMgY2hhbmdlZCwg
NiBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQoKPlRyeWluZyB0byBpbXByb3ZlIHlv
dXIgcGF0Y2hlcy1pbi10aGUta2VybmVsIHNjb3JlPwo+Tm90IGdvaW5nIHRvIGhhcHBlbi4g
T25lIHBhdGNoIGZvciBhbGwgdHlwb3MgcGxzLgo+Cj5wdy1ib3Q6IGNyCgpPa2F5LCBJJ2xs
IG1lcmdlIHRoZW0uCgo=



------=_Part_1_G5a5cMEoHajH5a5c_20251014135200=----
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
9w0BCQUxDxcNMjUxMDE0MDU1MjAwWjAvBgkqhkiG9w0BCQQxIgQgd+r2G9w5SGL/9Uu34ORr
J6lMtuNQsLZSCduOc3GWSfsweQYJKoZIhvcNAQkPMWwwajALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZI
hvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwDQYJKoZIhvcNAQEBBQAEggEAZX0B
bEktRhq6IBkRCiXwOx9N0Rsvu8LbsfcyE2FY6DrnzI5xKG2ooerqoRZz83DA8gMLp2gZ4VLB
iUrFq66jWV5Qw63vaLIvR+u34tUiacGANhPb/XETuGwjiUfvHEUwM2yuerFrb+3t0TEiQoeN
MeBX23eFhNtk4EIOx18kgAUH4t5HgvY+yof0MePLC/jSfNpIf+HfQm7td2RuiK2fzO3Lbc2S
UHHPTZu2uIX5opXjqQR9g/a1eVMW5XEkBnqe5NPW72paonhCOdDuPiC+kBbXlEbjYiGZlFmS
tkCa0fzbOHOYnIz5mVG5iDN6okXQBlg8ALNJW1Gi4IfVC05sNQ==

------=_Part_1_G5a5cMEoHajH5a5c_20251014135200=------

