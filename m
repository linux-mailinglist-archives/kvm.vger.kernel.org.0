Return-Path: <kvm+bounces-68321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F47ED330F3
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 16:08:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E9FCF302D2FB
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 15:03:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38C683396FA;
	Fri, 16 Jan 2026 15:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia.com header.i=@nokia.com header.b="q94thEUo"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010033.outbound.protection.outlook.com [52.101.201.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91FF1E0E08;
	Fri, 16 Jan 2026 15:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768575800; cv=fail; b=kPWRgpubr7XqaGGoqCdWGb2XRgOnmAXcXmZTkqPOs6/ZyX40/Ps3oCaDjgb7M6ipxTfnHWon34titK60MNZdpj5XOaxkzSNtCi0o2aKHUtS1RDZayIJ0FlDsBmRI4pXiWNdww6UmQRAfkwEJevy58/UbLzrs3nwhbTos2xXU6rw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768575800; c=relaxed/simple;
	bh=W6oSMARwdxciS8k6kgwSszDcuHtnYStd8UxA/phDL6A=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=B906S2B++/QEmlZ02w3WbZwdiwbvti0kHtGCADQWuZ40ZVevx5GWe5Q5ajsqqr9H6t8f0ITmISw5uq5o1yJtGcuYZ5gGaowOkOklWSVSjFddmTVldfy07ekOFqi2Tt2RB8vFjuVouzyQgAuCpH3g5czJmCVJJERe7mok7hVket0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia.com; spf=fail smtp.mailfrom=nokia.com; dkim=pass (2048-bit key) header.d=nokia.com header.i=@nokia.com header.b=q94thEUo; arc=fail smtp.client-ip=52.101.201.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QJtLRWr9vSdMvXCx5BUOPPzCm+h+BT+J13UZ7zb/gE2QUPU5EBixQDXanSC/WszlOzgzFJYPaAnZL4FGkapJw8jVwqh7mShEMF0/LK6UTqUpwtToA0aj0MZa8G2vfmuFtBJM+gDnG4covO51fP4gZVa9xPbX/yCE2t/ckSHpbkhQYiJD6vIyD2YuIBgQ2AjO+qeDRecLmFwX4J4vRfCtGTSpW8bOWD5/gk6/cH4n94LCRamTIPZ8LqorV6DckmddqKam9Q0idKWxv5GhkuPSUfh+a/dnriJN+9vn6cWFcYBZj54rld6qvks+xuW+2a6U79hLwIrK6jWZhbxvQ+cCgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rD4RrUQxCWzsRb6/Ad0aC7rLRyMC4U8yTzZ3prl9fgo=;
 b=AET1DXiQN8aef1rJlRSUx50AYBwg6r8/LDFIz0d7sQjYLzlxM/EmTQZPTv8BrFjdW0ySt3GzNQp98hjkTYI3xePB5jvx1AUVsJ+AGjnEK5eh0vDlS3GsouJjMwaHDFvmmrlxT9rnDisx0aM04tt/z4bEJrdlxQ851uJlCM2KOhHa6rr/Zve/Z6gEFnTB8ZCQi1zrTS110saqwreV/4ivSiFjUR6NGIfN9YST6cbzYrhxV+n6J5rv16z7uaToi8hwFv1GXh0e/A0qdATeBAoNhdNscVRwkcalMMt0HfLQ2j6xOozvEM60Uc7soRdZ0qRs4NpFyqPatFMG29Zjn07sVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rD4RrUQxCWzsRb6/Ad0aC7rLRyMC4U8yTzZ3prl9fgo=;
 b=q94thEUoD5qCNKSnulZhM083+/DcvFoJtNhNqAETFFTI+C+qEQS4/MtD/UafsL1uzQfssLnpAGNL/q8ekokX0QRMq9tr9RWMuz8wQ3lfvdUOpSDSWFwDP8dj8jNVXLimlQBr6+7ZQFpD10IS5aObiq1aJLc9plKuxAWi6LAyf5uJ/aoAexBke7wXb2doIPPXzdbPovB2sl2a4In+ArIhwNBcS264nDfQLF3vAxin6VKpQmyu3SOETmOb3ZF22il01V8eubwtfUXG1LxBrqko+ll3ENPHCngx0ZRR096NJQiBIxnYbZMIFsyAxddonj4EOae3B0o0Bhfj0n1eBK287Q==
Received: from BN0PR08MB6951.namprd08.prod.outlook.com (2603:10b6:408:128::14)
 by DM6PR08MB6204.namprd08.prod.outlook.com (2603:10b6:5:1ec::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.7; Fri, 16 Jan
 2026 15:03:12 +0000
Received: from BN0PR08MB6951.namprd08.prod.outlook.com
 ([fe80::4dd1:e1e:56b0:b178]) by BN0PR08MB6951.namprd08.prod.outlook.com
 ([fe80::4dd1:e1e:56b0:b178%3]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 15:03:12 +0000
From: "Anthony Pighin (Nokia)" <anthony.pighin@nokia.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, Alex Williamson <alex@shazbot.org>,
	=?iso-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH v2] PCI: Lock upstream bridge for pci_try_reset_function()
Thread-Topic: [PATCH v2] PCI: Lock upstream bridge for
 pci_try_reset_function()
Thread-Index: AQHchvhedpRiG3PAoEapw2tMBME4FA==
Date: Fri, 16 Jan 2026 15:03:11 +0000
Message-ID:
 <BN0PR08MB69514F40B402A06902578DE5838DA@BN0PR08MB6951.namprd08.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nokia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR08MB6951:EE_|DM6PR08MB6204:EE_
x-ms-office365-filtering-correlation-id: 7decfa08-ff61-4411-0ffc-08de55105e29
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?Uh/lQ7CCAZL0IO8nlMpyfnqlvX4JXddfSzLENWQ9D4LJt+x3j1PfphWhuK?=
 =?iso-8859-1?Q?xsyynyuCDqYmfGLnKgbzBppkDFRnufkorr4+mMJwjTsh/eccPGCFOGkBkq?=
 =?iso-8859-1?Q?vlbPH5NBju4k5aLHMIpg8nPkEOWVqY6lzNhgNkutXbCYnEp5yXYTjs/S3r?=
 =?iso-8859-1?Q?lQGansxtdnn5QbDxNRHTHChQbMP9EaYvTQb68RPqu4J+MXeMJq5N+F7dLL?=
 =?iso-8859-1?Q?0kOxauL1Y4YVqv0Eke3CpeQJqyP5og9YKnFo9FuJlT9nktEbbB9vHt03V0?=
 =?iso-8859-1?Q?Y9wTdglzB7yWTziYh3CHxb6z7yeifbAm0cJ/dBQ5rZQO8kYvgTNkxEpJNh?=
 =?iso-8859-1?Q?emTW5YF3UkbeY1gMPV3HGR8Egu6v74y9OsWbF1WPIdX3sNTQnfKeVuRKxR?=
 =?iso-8859-1?Q?UMSbJstn5sUIQN2yXo0CXdFHqXvvwFDroamT/B0tQKnjVgmTgTjpQcn3PH?=
 =?iso-8859-1?Q?tZegW/lcbpnN1NuTfe1rFOiaeJq0oGH4UAr+xTIE2RtBrlQ70GBYwLrVSd?=
 =?iso-8859-1?Q?5AsOweOM8armHUs28tJ0T9jgsp50aRaIYjm8b8Kkt38nvKiCdPilYsfVre?=
 =?iso-8859-1?Q?6yWQQv24is7G+niWnvB8AWPxs5liZgx9E8jghDFOtJjH/nA63aiv3LYzqf?=
 =?iso-8859-1?Q?DRhT0nDfaVE3tPzYTWMsX/vFlbT1jZPOhdZJVKpjUVl+AFnfMqXQat+vnb?=
 =?iso-8859-1?Q?IsXin1THZs4UoG4qMM24z/uA9vkirKgD+OSFgRdnRP1RwmyyevxEXpD9vw?=
 =?iso-8859-1?Q?P/thW6SVQcrQQU9P1Z682KGp2KlKCNwa/cStjW2K3zZmDSeFK3FGY78mXg?=
 =?iso-8859-1?Q?QUrfZx5yAOkN6ifypgzrWACRU9wOai+rcLR3XqaY9cR5pPrgPTl+PAscei?=
 =?iso-8859-1?Q?M4523B5u/FW8JTISMJe2fq3y6UMGCC1tzA3SVlVIgECYK3LUCXS88U9Zc6?=
 =?iso-8859-1?Q?eG96FKta8s6P/+vaq5KXsvrDllZxictEX2g8bgH2FrmGuyESsybIxPGAr4?=
 =?iso-8859-1?Q?piXVESOlrlHDU8l+jX2kpsDIQe6kcsgSxiq/Xg0/gjlU331y48bdb8AsnA?=
 =?iso-8859-1?Q?lYvjYRto2wdnIdJc198PYtgnTnxSaHKdzJt88Ic7vdRFLPx4O70g/Bioxv?=
 =?iso-8859-1?Q?Zp4YLkXAj/DqjiPd0Wab91Qs9XIClbkusWeS5pZVpJt+Qhyu4lbfln/r/j?=
 =?iso-8859-1?Q?ZVmzDlLJ02x36r/3J9xHTb8CQ5rQrjwDu0/IZzMeSfIgE27z6v+Iuh8AJT?=
 =?iso-8859-1?Q?uPjs22DSiaPvD6CHqj1NwEd2PMUXANWLh3XNvKK2Vu8EBprRfC7ciATJ8Y?=
 =?iso-8859-1?Q?P+fGITwlNyKDLrbCzJ3+EMYbude3NHJdQgemk8IOIhApZFnOS52C5Gj62B?=
 =?iso-8859-1?Q?hUL4icZSYk81+FkBCQOZ2MkzJor9OxSPYopzySv4EK1DrHxiHunjkDi6RO?=
 =?iso-8859-1?Q?RxO+T6xP37z/bYwz+B8tpVhoo/EsB9pwOcEcNk7slGdaGgIUogIjd89/fG?=
 =?iso-8859-1?Q?vqJ2z5fNFBAOCBilL4+O/nKjTYPZyRDQRQR929P8GvscFqROLoSuOvnAI0?=
 =?iso-8859-1?Q?WWCw7JhdoJ8kaldzDJnl4mQwkjUs3sBTxmFUUgQ8H+utxwwxKeg3tbq02K?=
 =?iso-8859-1?Q?O4VkJkD6dZYCgUTYNY8DMOv23vjlueYfalzKTzMW0JALX2kgTaNYr6hkNC?=
 =?iso-8859-1?Q?ZZC0g2xLoRkaLRhFKaQ=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR08MB6951.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?Deztr0vP+9X7CoucbrJPJZwyzYrdBDRBTrAS4bwn2j7dyP/XSUrdE263t6?=
 =?iso-8859-1?Q?p2cX0sTLpY1tikr/YYh7vsrx0hCoJRPi+2tNzlNCglauwssmUuiSQ+e0BT?=
 =?iso-8859-1?Q?JTOduY8QrIHuUYnqxVtmpGk5gXbgh2S4aB5TwDQ1ZXbCicWw1oQpsSQPeo?=
 =?iso-8859-1?Q?cRG58ddMuYOriehMsIpXqNYvWzScrwdQR/dXbXNRQsgRgYd3rQFuZwlJAg?=
 =?iso-8859-1?Q?4pT7R/+1qhVE43RrFH/0bdiYka/R7Eiej4Py1MkHflmhcvife71WuxWxWr?=
 =?iso-8859-1?Q?dJ3HNt6t2pCPalzVmi/KybJ70uIo4VxPtPuhkbLWud0cQptM5ji7jZZqCE?=
 =?iso-8859-1?Q?mkZ/tE70Ep/z7Syhbj8BfqRz6UaN+xJfgBAg+oq0OagatnaSyqmf2BxJiN?=
 =?iso-8859-1?Q?5rBKZEnyWytEMCZ02uUjctkBVSp98ICXqsxT5Q6a2CaPv274p/OZLHAWBa?=
 =?iso-8859-1?Q?hA68g7/6npYopzuYi5KKo53oNujtE9ssQuQIjyVoLvFgqrn6lbT3XK/SHz?=
 =?iso-8859-1?Q?BBsOS+7rV65bEGk/B6s32T+RvxqHOUeAgJmv4mSsfICvCo8BuGQ3IHdocO?=
 =?iso-8859-1?Q?6X2LxQ82XRAUT6HV/Jgkw7ryQsOU3PWU0v/ZYbUZTWeIu3ebKIe6ciF1Mh?=
 =?iso-8859-1?Q?taC3R1ORtDWDr9EVl8dTPtnKNCGNfn1aeNNfFxIo1H7k9uQc6btQ1pWvBQ?=
 =?iso-8859-1?Q?t9lamPXUfT6Gh+Q9lp6COzRmBFgdaarI8FWUTRzWXzsQLwobbcgzp3iU5w?=
 =?iso-8859-1?Q?pM1j7Te5Mx8FN3TIBA32ywxtjm4Ysrf/cCPUYxOb4JJfGYpJuluxmBAM4u?=
 =?iso-8859-1?Q?hJNdPB4R+7It/PpLm9ifppc8hESstpjh0Wvp99gTY3jGo0XQ5lm+PlOiAW?=
 =?iso-8859-1?Q?YXl1db+MqQ0ZbP4ZSjKVCy85LVoiRqFAc6Yjy2/WCzULFWj2P9oLyxi9JW?=
 =?iso-8859-1?Q?Wnf+3369lHuRFx1CccmurjXG9wBCvURlqXXeCDc6SKbDSH5LTA2sYd892j?=
 =?iso-8859-1?Q?WMcMf66yoVzibNgOuYRbvKBGZw+6i9tYAjvWajMy0raB3y5Kfz4z0HHcj9?=
 =?iso-8859-1?Q?COHaplcf/BPxQZS49xdBoeRfHVYFzLJ0mAZC4aDTyOY7UuX0bjWzGb91l0?=
 =?iso-8859-1?Q?K6ohq5MmUSTgBdd9qgSCgvgbaVVU1h1TmcONdOy4v8ccQf1rDeZYnn/3mh?=
 =?iso-8859-1?Q?eQs/tsKj6sLubgkFFgFSGe7sqYaaY/DUcAd7FPmVSmSxJiZJBFhJL7N6vW?=
 =?iso-8859-1?Q?Q4/I1jgoBqmD04y+zAUlRIl80P8Ko6k5avz3wLZ0ssg9NlYXJ1S+4AVoKv?=
 =?iso-8859-1?Q?h7aUKGvhzrK0OWPD2E3FzBJi1NWo7nYBdrVoRB0JOI3GzEGo/ONL3N4dzQ?=
 =?iso-8859-1?Q?r+ZZOgZnsKTMF0ffSITb1bWC8ulfRipNTJZAM8hf7NJ9F3UbhyH8G+UFU1?=
 =?iso-8859-1?Q?BoloiJ2g6x2YyhfAIyl4NXrwdR7txMTyrrK1wKZcW2+QsjJVpLBb4Bojyk?=
 =?iso-8859-1?Q?Ib2EYWzZNs4CXQJoUu7ROykzg7PvZT9WVkdYNzDTFaD7HvZGTAiH3zXUD+?=
 =?iso-8859-1?Q?jz5PV7P555GTPqQ3DHXGbHVMOPJL5J8flnhKsIY7cnGaaZGCMZF7v5gLeX?=
 =?iso-8859-1?Q?iFgqDeX1ZEDwnPLKKqPOUdGtlBBssK1YhU1zPCe5JusYRjZw/UyiIH+U+B?=
 =?iso-8859-1?Q?gQ6pkauQg+spMucTT805SDd23sAIwmumqq2FN0J0VKirgXqgnOc0EYPCve?=
 =?iso-8859-1?Q?YKuKkk8RDyXwrzKLzZs/CurppQDfWaArV14m+Q+NrsBz4lgXgPMnWySiVv?=
 =?iso-8859-1?Q?X9XTl/ggUQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR08MB6951.namprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7decfa08-ff61-4411-0ffc-08de55105e29
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2026 15:03:11.9628
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wIxKGmN9IaOA9dAwAWEmHSlk5rNrh16gsOA0Gj3/YYfNqz5BoP0PjRYsDBVC6hAQ19eIMpxhrFyyntEhwZW6tYL5fE5DCAyQdgwvFHBpwYc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR08MB6204

The commit 7e89efc6e9e4 ("Lock upstream bridge for pci_reset_function()")=
=0A=
added locking of the upstream bridge to the reset function. To catch=0A=
paths that are not properly locked, the commit 920f6468924f ("Warn on=0A=
missing cfg_access_lock during secondary bus reset") added a warning=0A=
if the PCI configuration space was not locked during a secondary bus reset=
=0A=
request.=0A=
=0A=
When opening a PCI device for VFIO userspace access (vfio_pci_open_device),=
=0A=
an attempt to reset the PCI device function is made. If the upstream=0A=
bridge is not locked, the open request (esp. VFIO_GROUP_GET_DEVICE_FD)=0A=
results in a warning:=0A=
=0A=
   pcieport 0000:00:00.0: unlocked secondary bus reset via:=0A=
   pci_reset_bus_function+0x188/0x1b8=0A=
=0A=
Add missing upstream bridge locking to pci_try_reset_function().=0A=
=0A=
Fixes: 7e89efc6e9e4 ("PCI: Lock upstream bridge for pci_reset_function()")=
=0A=
Signed-off-by: Anthony Pighin <anthony.pighin@nokia.com>=0A=
---=0A=
V1 -> V2:=0A=
  - Reworked commit log for clarity=0A=
  - Added a Fixes: tag=0A=
=0A=
=0A=
 drivers/pci/pci.c | 17 ++++++++++++++++-=0A=
 1 file changed, 16 insertions(+), 1 deletion(-)=0A=
=0A=
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c=0A=
index 13dbb405dc31..ff3f2df7e9c8 100644=0A=
--- a/drivers/pci/pci.c=0A=
+++ b/drivers/pci/pci.c=0A=
@@ -5196,19 +5196,34 @@ EXPORT_SYMBOL_GPL(pci_reset_function_locked);=0A=
  */=0A=
 int pci_try_reset_function(struct pci_dev *dev)=0A=
 {=0A=
+	struct pci_dev *bridge;=0A=
 	int rc;=0A=
 =0A=
 	if (!pci_reset_supported(dev))=0A=
 		return -ENOTTY;=0A=
 =0A=
-	if (!pci_dev_trylock(dev))=0A=
+	/*=0A=
+	 * If there's no upstream bridge, no locking is needed since there is=0A=
+	 * no upstream bridge configuration to hold consistent.=0A=
+	 */=0A=
+	bridge =3D pci_upstream_bridge(dev);=0A=
+	if (bridge && !pci_dev_trylock(bridge))=0A=
 		return -EAGAIN;=0A=
 =0A=
+	if (!pci_dev_trylock(dev)) {=0A=
+		rc =3D -EAGAIN;=0A=
+		goto out_unlock_bridge;=0A=
+	}=0A=
+=0A=
 	pci_dev_save_and_disable(dev);=0A=
 	rc =3D __pci_reset_function_locked(dev);=0A=
 	pci_dev_restore(dev);=0A=
 	pci_dev_unlock(dev);=0A=
 =0A=
+out_unlock_bridge:=0A=
+	if (bridge)=0A=
+		pci_dev_unlock(bridge);=0A=
+=0A=
 	return rc;=0A=
 }=0A=
 EXPORT_SYMBOL_GPL(pci_try_reset_function);=0A=
-- =0A=
2.43.0=0A=

