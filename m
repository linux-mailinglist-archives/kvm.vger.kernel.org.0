Return-Path: <kvm+bounces-73260-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IE2QKvhurmn8EAIAu9opvQ
	(envelope-from <kvm+bounces-73260-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 07:55:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 5754123487D
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 07:55:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2A28A3013DE5
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 06:55:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 145843624C6;
	Mon,  9 Mar 2026 06:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="JnRFZQgj"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.mr.icloud.com (p-west2-cluster2-host4-snip4-8.eps.apple.com [57.103.68.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162083624A6
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 06:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.68.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773039323; cv=none; b=t99tUnwLExs43jmBxKdJFJ2RIHezahPWGpkxyo9IBOkdTxiDtsgHQvE1orBQ8gTVseNkRqOvZsa+5cVtQxX5tjao0pHBSDgT2IaQbWqoacLMBGCUNA3OyAt8eMeprxlqVFpZdFhTKa/Y53hm+AZkicGogAnHWPPNirizlSIjM2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773039323; c=relaxed/simple;
	bh=gsK5OvwyqkWoiBY1mXoMucvc9CuH/TrbMstXOjSt5VA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=lpwiQmfk2YUaHSsuCubg/GRbq2lMC0SP4F7F4p9+YhlAQjP+FRSYBqCOAVRfvP8tUtsKABWF6nTbBZ+s1t3mqFPnCZPPeyLb1oEvh85j23QxAGSuOrYc1rvSe1UbbyZ3QwY7YW0M1uGj/g11hFM1i69Pfd69we+Y3uv36YOsrwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=JnRFZQgj; arc=none smtp.client-ip=57.103.68.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-9 (Postfix) with ESMTPS id 49A2B1800145;
	Mon,  9 Mar 2026 06:55:17 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; t=1773039319; x=1775631319; bh=gsK5OvwyqkWoiBY1mXoMucvc9CuH/TrbMstXOjSt5VA=; h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To:x-icloud-hme; b=JnRFZQgjbqG1JrsESB01zyoO2FR0wlinaw3g5DNF7KoYVzHtv0yyPHJHBX8e62/0nc6iq9ptlCATa+Qvp+uydS0l5NQFhxSx/NZWlqIXBbxY1SykL6fwTto80OybB0HZVEotk8SayGRBr1CeJr728dMXHb92naJT3+hu7zj0B7ZhCpDnxrKJ0OJIv3zRzlPjRIYU8H/oGDJSFlg0RFgMBHeOlfDp/U/mMxNcpp2HIg0z4XIN9V3/AbnAXynfe0PHa7FvMRUOvHTZefSId74af81FX206VdxBsx3lxmIl6P73En3ySSgzjaZlnDt10pLfdEmgo465w2VbPd9hQU+r6Q==
mail-alias-created-date: 1752046281608
Received: from smtpclient.apple (unknown [17.57.152.38])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-9 (Postfix) with ESMTPSA id 6D51F1800138;
	Mon,  9 Mar 2026 06:55:15 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [RFC PATCH v2 0/1] target/i386/kvm: Configure proper KVM SEOIB
 behavior
From: Mohamed Mediouni <mohamed@unpredictable.fr>
In-Reply-To: <D74B0637-1332-4FC4-B29B-804E5AC18C33@nutanix.com>
Date: Mon, 9 Mar 2026 07:55:03 +0100
Cc: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 Shaju Abraham <shaju.abraham@nutanix.com>,
 Jon Kohler <jon@nutanix.com>,
 Mark Cave-Ayland <mark.caveayland@nutanix.com>,
 "marcel.apfelbaum@gmail.com" <marcel.apfelbaum@gmail.com>,
 "mst@redhat.com" <mst@redhat.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "eduardo@habkost.net" <eduardo@habkost.net>,
 "mtosatti@redhat.com" <mtosatti@redhat.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1279CDB9-C8E1-40A3-A01D-3C53E831989F@unpredictable.fr>
References: <20260309054243.440453-1-khushit.shah@nutanix.com>
 <6A894B95-03A6-49EE-91A2-D3BCB09AAFCD@unpredictable.fr>
 <D74B0637-1332-4FC4-B29B-804E5AC18C33@nutanix.com>
To: Khushit Shah <khushit.shah@nutanix.com>
X-Mailer: Apple Mail (2.3864.400.21)
X-Authority-Info-Out: v=2.4 cv=ZPHaWH7b c=1 sm=1 tr=0 ts=69ae6ed7
 cx=c_apl:c_pps:t_out a=9OgfyREA4BUYbbCgc0Y0oA==:117
 a=9OgfyREA4BUYbbCgc0Y0oA==:17 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=64Cc0HZtAAAA:8 a=hq2CCHQ3Zjmsdc1K5isA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 5pm00IWxl8-ShB0iJ5or-1Xmk-1YYEbz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA5MDA2MiBTYWx0ZWRfX7qQ4IphH2nlr
 VCcCRmZnogyyA0YZ5WhRS2tIrFSVdZ6+glSdQVEfeBByCaqB5XxAnVmkHNRkLGjXEeWn8MV7Pmu
 gqj5LLOZ94b5EXwM6rMK6hy2BsPEZXZfAJj0GQ/8fJeMy22dts0njwPdnvjPhZ2+vDC3Aa9onrt
 JdfyaSD2w9ZNSq7nEHZRzMuy+bXTY6jfgZJ0rEONkrLb24vRz/f5/ouNoZYDQ/0oDhUB5wFemey
 YJsE95TkPPdiabX6DlT4E9eYBI/2WlDX8x7aQK5O2zbRg3VwEVzo/6IpRIMrB3xYldQCnU7M4IX
 bWpHOQNDOvQ6Izg/tWUGZIskQWC/tyHhpD+Hc7zEaKjNH2jO5E9zA28/aRA8CU=
X-Proofpoint-ORIG-GUID: 5pm00IWxl8-ShB0iJ5or-1Xmk-1YYEbz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-09_02,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 clxscore=1030 spamscore=0 bulkscore=0 classifier=spam
 authscore=0 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2603090062
X-JNJ: AAAAAAAB+MIfcgwaci7uk5FEu/ujmzNgXYaDk9qGAxJv6IS7K5po/IDyJeqkfwaDYxQf1dymAr0xWtvuMBMcktu7RmJJGZwyRzpkqXo5zZgLGLL8iRWD05Z9pBMJ2FeTWZlhP5+v7Umml8BjOMae/LxEvPH9MjL7pgcgeECUsxvnMqKBMD+Y3XkNGpLoEyf5gYWKHi0r8yKf9CV0x8thjL9M7FhvuP3fUmcCNJgF8MSep13gQkqH6u7n5Rw9Qs3vC2IKruhw8egrcWBkuTffhoy75V7+e77g9XOae2CTU7k3b9OluZ0Oxh336h+9oROCu2dsD7jfKDnzme+bP2BSgiQ46j9e9uWJA9bx8wS/WIUZ5sCZS8P+0dp8Wv6rWAQl0WlxLPpgJMglvswoS33HkpiIXrHd/87lgKnUXP2Z50J1HXYM/HPyotNu+g1N0mmjEFdwjG8fUtnc7fsl3ZVMJCg353fxtOU1AN/UgS8CfcYsKkwKdO5E1wAq22yewo4UtiWSIPzZvESgiQtZKleM/Kg6OR25Dcv6HdXKu713/fnOSxVhvFj5iH3V81H8HawVslIPU34LBis/zq8WSwlextmZaLNQj7Iopsk0vf5msVQ5gJb0DKbd2fo7DFEjXXHJf1upZFunWo4S9tOdgCrDvNhivFuVpP1EC2fZAQjiUlcOcUtAKRSsxwDIpDJwDW+FmS3+Phn24YokPTbgXwk/j788J4vpDyX8bdJawXTaP6D0Y07q7rcjl4Rhz+SDcv1XgPBdjI10e17qRretNcwDRATqugwv
X-Rspamd-Queue-Id: 5754123487D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[unpredictable.fr,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[unpredictable.fr:s=sig1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[nongnu.org,nutanix.com,gmail.com,redhat.com,linaro.org,habkost.net,vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73260-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[unpredictable.fr:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[mohamed@unpredictable.fr,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	APPLE_MAILER_COMMON(0.00)[];
	NEURAL_HAM(-0.00)[-0.987];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,unpredictable.fr:dkim,unpredictable.fr:email,unpredictable.fr:mid,nutanix.com:email]
X-Rspamd-Action: no action



> On 9. Mar 2026, at 07:33, Khushit Shah <khushit.shah@nutanix.com> =
wrote:
>=20
>=20
>=20
>> On 9 Mar 2026, at 11:27=E2=80=AFAM, Mohamed Mediouni =
<mohamed@unpredictable.fr> wrote:
>>=20
>> Hi,
>>=20
>> Ugh about this one, but am still convinced that a machine model =
version
>> is _the_ right way to deal with this. Will this be backported to =
Linux LTSes on the KVM side?
>>=20
>> Or alternatively, what are the odds of having it fit as a CPU flag?
>> For example -cpu host,x2apic-suppress-eoi-broadcast=3Don.
>=20
>=20
> Hi,=20
>=20
> Thanks for the review.
>=20
> Regarding the -cpu flag: This doesn't feel right because SEOIB is an =
accelerator-specific (KVM)
> value. Tying it to the CPU suggests an architectural feature that =
wouldn't apply to TCG. What
> specifically feels off about keeping it as a KVM/Machine property?
Hello,

The reason why I considered this is that QEMU CPU models are versioned =
separately from the machine
model, with an understanding that an older CPU model might not work on =
an older KVM.

And with a common CPU model being also a requirement for live migration =
too.

This has historically been generally leveraged for security mitigations =
but it could be a good fit here.

That could provide a path towards it becoming the default when -cpu host =
on a supported kernel (which doesn=E2=80=99t entail having LM support), =
while keeping LM working and having it stepped in with newer CPU model =
versions, which people will update to more often than new kernels. Maybe =
the best shape could be a no_seoib flag for older predefined CPU =
models=E2=80=A6

My concern is primarily somebody installing a new QEMU, running =
qemu-system-x86_64 -M q35,kernel-irqchip=3Dsplit [whatever], which would =
pick the latest machine model version and fail straight away if this is =
rolled as part of a new machine model if running on a kernel without the =
KVM side merged in.

And having a custom flag not turned on by default for a long time for =
this comes with the risk that almost nobody will enable it instead of it =
being eventually phased in as the default configuration=E2=80=A6 Or =
maybe it matters a lot less because kernel-irqchip=3Dsplit is not the =
default today anyway?

Thank you,
-Mohamed
>=20
> Regarding the backports: The KVM kernel side is currently in 6.18 and =
6.19. I haven=E2=80=99t yet came
> around to manually backported it to the older stable releases yet.
>=20
> Thanks,=20
> Khushit.



