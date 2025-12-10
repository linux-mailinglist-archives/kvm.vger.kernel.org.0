Return-Path: <kvm+bounces-65646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 41631CB1F58
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 06:24:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A02B4301E918
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 05:23:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BC422FE59B;
	Wed, 10 Dec 2025 05:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="OR+NtRy2";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="oZoi5hTF"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DBB271457
	for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 05:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765344233; cv=fail; b=u7mT7ird2Jp7kIUjNuJ3+yMMqwAecINztAFiwHlfTX5WAM0RaUapuxhKhFR8D3GKhuO+XrR7FG4GEIQYw7/Hv7JKSyeHs21QPEur2faWCfrgQJgwwNeQRIFzBmWsd97Kp32gkUCI0RttU4kYRDgA4jo2yNotLxisuMmsov0D1MI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765344233; c=relaxed/simple;
	bh=PLmAk1gnQ6XH0CUuZak4hFEc7UPKd19OCpN/YI3A5og=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=f8MH/xHiPZ3kpP0m6iY+JM4l37hStmA7BDrGmNpTru5Hqi2jY5wK0yI/DEGZEs5ZLPDV55l2dgbA8G8aBx+SR3ThzFyyQO/s220UXOymsGYTrL4EtJjA+TvFMpO5jwQohVYxugAkWWCLmzmZnkOp0Rim+6sGE916wbXesU1bdg4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=OR+NtRy2; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=oZoi5hTF; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B9L2JoB945755;
	Tue, 9 Dec 2025 21:23:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=zAr5sSG5gQVtoioZaWgxGvXRkH4HC3OY17Yw+XQ9H
	lQ=; b=OR+NtRy27UhyBZmCMuFXgd8V1v+KeWzc5wPErubHYWWArpzYtVzms9vZg
	UkXHAbpAf8fNU90SnusJJkiTpN+J5iq+ZBY67/tVPONUl2JFllgKbfLmFVAr+NmY
	b27DLKT36iHE9047tUfYd3nXpH/TAUReLQ7tUkRo2YTvbwSfmFabRJ8XQ6UUse47
	/gCsglNcMnXr6+5ziFOw1zEzOWJb2xdHZtjwzLdgyfVCPFY0mN9fr4OHdkMqbgNO
	Zc2FdoiwTNfwPOdbsghcHPJvJoWb7OmAu+uiAa6zgbmEDlGH1XSo/G9jzKGVxT0j
	ktFsxJUg+JQTFXZ2ndcn/k05xvbcg==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11023076.outbound.protection.outlook.com [40.93.201.76])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4axub5udj1-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 09 Dec 2025 21:23:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jzmb8ZTfx2838WEBAKDHkHbpCE81TRzwliRp1kv9zVlU1WyvbudwYaX963VPFuraerqZ0a8VWxmmRh3VIrynRplooTQK3XgcTDJO42q2Mb9aVU+PLL8fWwa7amIu7GxGKNCtteoN7u2C69ARLOaUBMJ4Hsl3Ue6MiObQc5xdnVyUf78Cd5o6A39IUS0oSLzyXg0j+pJ/x0BiShkAoRz0TB2s/fC0kx7QABxaOIyTi+QD1a2apDgWuneSnSkKzqlPMEJa0sMYL4VO5KYbsXyuKFUacRL0/iea0wxomZcGE+FyK9KUdWQMthiAYhsaPII4qRIgk6iuSVVOaMBpYxo+6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zAr5sSG5gQVtoioZaWgxGvXRkH4HC3OY17Yw+XQ9HlQ=;
 b=hfnCAXjQ+CUiDdwofC2eQZVBYD1uneejU+TEuQm+NZXek+EKK7I55JZ5kJ9edzntlwMFc/j5F2t9R2gRmkLWA6Y2Rhs77XUCs+/WtcwoBEk6SaghZLAfNEajrKMwO8ESN13DsCktZLGtk0I8AjmueSMAgMHYrlEqkA+roJGSgkMebDn7xsT/MH2cvst6AdC9OqjnPQQTssya+gc5XpSxgVPJj26wW+WlHBCy6kiSq3JqzX7gEbrXLSZfFT7UV6N1OL5P807ovD+HQsygvX4yv77QSVMljkGDwUjTUUkTyN/kPBWPm3Tlq+Ij/mm7ET8aQnQow9g1RiDHu7VFu3q1RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zAr5sSG5gQVtoioZaWgxGvXRkH4HC3OY17Yw+XQ9HlQ=;
 b=oZoi5hTFzaSiX6CDSzACgPuKPdolciG2PvY+b1JCpzJGOfiC/ktkDXDb9hcKTGhFWTVWVRIsUeiyLRztUhUTqriQA3FD4+2BcdEEYtfWXV7YuHoW2yKfVgRVRv4DGx2/iwoaQP1JBKKel3RbAmDg8E7TepDWUft6rQ+rjRIVOy+9DR4/f8KyXvuJzR05e0CiUfX1+0VrpxIkobDaTqQ+1rcmHgylU+lQMw6hszof7rtmCFEctcZpNwDCTJ4csToo20UuW2gUIkD4V1KBY06T34wleeezu68NJPCFn26LDBBD57Qksrm2kw2ZtUvYHz49NceqFikV5HnmkKn7GXL3ug==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by CH3PR02MB10533.namprd02.prod.outlook.com (2603:10b6:610:204::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Wed, 10 Dec
 2025 05:23:25 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::27c4:c948:370:572b]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::27c4:c948:370:572b%4]) with mapi id 15.20.9412.005; Wed, 10 Dec 2025
 05:23:25 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Eduardo Habkost <eduardo@habkost.net>,
        "Michael S . Tsirkin"
	<mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Marcel Apfelbaum
	<marcel.apfelbaum@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org"
	<qemu-devel@nongnu.org>
Subject: Re: [PATCH] target/i386/kvm: Configure proper KVM SEOIB behavior
Thread-Topic: [PATCH] target/i386/kvm: Configure proper KVM SEOIB behavior
Thread-Index: AQHcXrhurlricMg9iE6/H6LGVi6DLrUEthqAgBW2oIA=
Date: Wed, 10 Dec 2025 05:23:25 +0000
Message-ID: <C1DC0AAE-AE34-42E1-A15C-E03D1EE4D770@nutanix.com>
References: <20251126093742.2110483-1-khushit.shah@nutanix.com>
 <F09B2DC7-6825-48B4-94A9-741260832167@nutanix.com>
In-Reply-To: <F09B2DC7-6825-48B4-94A9-741260832167@nutanix.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|CH3PR02MB10533:EE_
x-ms-office365-filtering-correlation-id: d9f596a8-f464-4d6d-cdd2-08de37ac3e77
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|10070799003|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?eL2HUNrKmFz+DMeiu8wf5YpMRyVDBmyEcITkTfyQKsJ0wSP8LrzlvGLUxVbb?=
 =?us-ascii?Q?Nxu3G1/sAmYiTVgSvRHuU6xbIW3W61Jo679BDETw0ETLXjyuLN5xWU8IRKbL?=
 =?us-ascii?Q?zyIR9F7BQFHMAPoDA3DmgExhg+UDAgn8sihBBaizKKtMFnPJBIkg8XYZrxHd?=
 =?us-ascii?Q?7cYtxmS8V/V/IDEjaa1lUT1IQBEY0ZwGT8t+ceP3vshC34KcpKKb8h1MVZKR?=
 =?us-ascii?Q?iKrZ/6ZgkjFX5vNQPSzcZ8MTaTewE4aL/L4ErX3EsoUliMu7vctguiZxZQ+9?=
 =?us-ascii?Q?/xiONiKGSqlsxOl3KWs0oEcGct/Yp6fUaofxzn0PFtCsa/+IfE9VEJYi3Dne?=
 =?us-ascii?Q?GUTWP8pSyqRKGzINauQ+mJ7ie2IHMbpdAm66hZnH+bQaLQgZfM93AzVwEUFX?=
 =?us-ascii?Q?etkoDJ3vw1TfduK5WuzY1DDpCbcvhu/FQuBxnc/0As4Nar0crL3SY/m++Hcm?=
 =?us-ascii?Q?TIh4bbKtRIdc68qmnqeRY549SSnn9cjsV+MjZX0HSRUPrR6Tr1c8c7S9x65/?=
 =?us-ascii?Q?Kvbul7m+LVwyBdW4+OErvhXO7aXTxoLrcdfQbKZIk7vkkJ1B5MNJ0C4/MBcE?=
 =?us-ascii?Q?wHoXl7mrPAAkwlM5Okvnv1Ioe/IUtcKU7bdYKVcEEtQfmGjHAXDCJg9GIxId?=
 =?us-ascii?Q?+KT4IHB9zMlbA6b0vc9bS5FT+uh9VnFdEyyP2WafJQCFKO1NCIww1W+rWSVu?=
 =?us-ascii?Q?Z8Lk3RNhJdyq3p834abr/3aRJO/mKvgfkzsRCBnJ7KMVulskL+UT8oohmLow?=
 =?us-ascii?Q?uUlkpgVPSdG32ycSUjh1MyMjvsc9Y/xjVT1kJhNH4LNL5/MFhd2OvGvKtw0c?=
 =?us-ascii?Q?upEDdZvNmTDna56M7P50W7Bpl19/8LILJgPf2g5DpX4N/nlxtyKwZdbrJ9ls?=
 =?us-ascii?Q?HclmArN58t4cCXN3ekO4hJWqzNBmwsM+2vgHJk8QoDp92IXfCuY2eQw5FLbv?=
 =?us-ascii?Q?TFclry4EqgQtI3NyT9822/dtwtOXxIx2XBf1xOYdqFv7PSdK5stVsSXtlGPJ?=
 =?us-ascii?Q?S5tpvmTWEeUMlFsqBKpzuKf84v6nerecIWfkeVJIwqC3GgyqQIYaPVScvRRU?=
 =?us-ascii?Q?uPPW5+/3es2T/9fDc/pI4SfHOZ6JHuoCzM6IyRUV20PaPtNBYLlC//VHVNX1?=
 =?us-ascii?Q?wFwhs4snD2UY0SmHtnEbNK1n1e8BH4RcRkb0Lge/8kjyj6R7jYYe5U6R8HQq?=
 =?us-ascii?Q?2HUGwaPnJ8MvtaYTKQ6q/oCetZrRWVlWbIYIsW/uSgQ0854tAnw5yI7KlWcA?=
 =?us-ascii?Q?KGUd6duv8+w3wnj6oedpVujB6fDtjT8W71Nz0lqlkSYGLMw4NZQiq+OfMNqC?=
 =?us-ascii?Q?vZ8TpceeQL5N6OOzCe+z8CrusgeHHgbUS0QDBCV6NF4jVZF4KrmuuBI+Wvxv?=
 =?us-ascii?Q?gjAghPB18W5pLjVsr/2CraTuoSCJeZkd5UPJeOX63ZbnObT6wXScibDkLele?=
 =?us-ascii?Q?1KPN+Ui8neuxSDj/Cs9+SUFIvH0d585dGk4kKFBxPTqJd3zx4VwNulqnDz3D?=
 =?us-ascii?Q?hNw/hFXNxBmClQ6Lq/gzpTLK1CWEgUI+FHlh?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(10070799003)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?XCqSeNtRn/LEYQIbxd3jcs6+SFIUqGSjtw2aJfY/xARzhdwB0+RGPaIBT2se?=
 =?us-ascii?Q?pMuuQL/RqxfTmbcQHQHIhtfPo4BufwiGklJFb2bPJCwQA475suaPWxgs726l?=
 =?us-ascii?Q?bH2/lk4LHjh89+vz0xQKwjvQjP3Ej97r5I8pXicqPv9L7kyO/QBXRx4p+xN8?=
 =?us-ascii?Q?oUF2d7pgz8Q3a2SIrn/aSva1oYUnfYsYjjfI20kJpNwg0pHdWt6daL5j+ryw?=
 =?us-ascii?Q?d9ZDrtFZXMFY0SjwkL19TM5VTiUNureV30gKGJHc+4wmUs0fjqHPEbtgNmJg?=
 =?us-ascii?Q?3kiu0FC7N0YdtkgjjV6dPaKZ18rKqY8wEQ9DJK9vq1hoMu8eeaglBG4ptNHH?=
 =?us-ascii?Q?miMngAlRYsIOQWllT5HnXg//L9w81KbEkj+FAFaREVmfCIs2gCj+fyGfnXUx?=
 =?us-ascii?Q?ab8YxzI1T7I2TPd5lkTyqp1PyDpVYjeSBTOJ6fLRUsNV8O7d/sgimzFFjvB0?=
 =?us-ascii?Q?iTjwwLNS5QFxc/IA3rUHzAGzUwVRKJO13tHZ2OJc+nknepzJBfKuxkwOxSDA?=
 =?us-ascii?Q?qtXRiKLznC2QeIg6ZLj9jQntXoVZksVpRWa2xnuqFGnsOtOy6Y4sOgQXCKSa?=
 =?us-ascii?Q?cfWd0juZZaZIq/1BHE0rt1p4sgQtDEg7gGU3XOjFoeYwPU/2CUVjZoVIAcbb?=
 =?us-ascii?Q?w029iBBahBi/UT5ws2ZGLG/tLMP1a1sMXMyRqlvI8V+sOAkGD5Tza1IhXWjL?=
 =?us-ascii?Q?0+yKA4l4laWAAvxxyLy/VICy+K2vO7mt0rbnnRHMtGMkofrOJXpwDXsxdp9u?=
 =?us-ascii?Q?kuJhJD8Ce30uQ5toLn2f2Gh+46LkXoYQlAdJPulBw4w6bNOjFt840I+j/3qg?=
 =?us-ascii?Q?eD8dva7jlbGXVUfpweC1raWCJ63jONruPXT+1KHa30vpGHxQfFaGtcdg7iXX?=
 =?us-ascii?Q?TCez/RlkC+aWmRDAS3KQcZRFnqswC+FR3BFaV2Z21Li0J8hKuw9Sz0wy30f5?=
 =?us-ascii?Q?9rsg9nqIJIbKbVoOCGMkNWcZeObL2kPPSaOxS/mNl5w9pXtTMpWHbGxQ6+Jf?=
 =?us-ascii?Q?D5fpxYxov/3GHCP+Mz+Qg0NuUbbXYStGDHm/Q/C+CaXXir25FzrNe4WHZM3z?=
 =?us-ascii?Q?1jSdBYqePcbxdf1gTITKl3369WxE6Ug3qxAcWsLCE5y5KPl/f7OMtMQ5wyzd?=
 =?us-ascii?Q?Y0p+9d68sXDeae+VhYVxEoHzW4eibIMNFm3eSVqu803B7pBiJl5cFPdlXkgi?=
 =?us-ascii?Q?Kn/dG8+7WB5SLqWLbqJtsjwOZDuwhViEwI+5N2LPjTUAaIDBUNn3b5dde47M?=
 =?us-ascii?Q?oh8PNkLKMdp+Lo+6vb47O2IIzz+W2G2UieOf3Shexgx2VhdQeyRXZIyrU9Fk?=
 =?us-ascii?Q?h1Qg7cJPT1O1AtF41A7er5094K/Er4aGMCm6QGA8/QN9pF2pV225zMiL7qif?=
 =?us-ascii?Q?449Vn9KIQpmUXmw/z1TKwbfAOZkGzHd3/K+PMK0KzohtFmlb7dz9IFcQ+AN+?=
 =?us-ascii?Q?9doO4T+Gmt+BmnzC8X1Xv5VF4o9tmGEpx/+ofLtAywgC2bzI75A2jQiRZcc6?=
 =?us-ascii?Q?08nAFXMFOwQqxTC43ikC4ySgHGl19vDWTJ6RIqgyd3iYYL3Y8XrdMCxZl0Bi?=
 =?us-ascii?Q?+yAYCD6iQiS/SRbHPPi6kWLz8RYn0J5n4pqYV5TextnZ3iHLGlicaOwPKyIL?=
 =?us-ascii?Q?m3BHDgsrRnxgLv3/vW/Xt/5abNwT0GZVQoRAuS+/Vnj44PbOdpCalcNlytZp?=
 =?us-ascii?Q?uJCspw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DDFA208F36E1A24091B734F871B50593@namprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9f596a8-f464-4d6d-cdd2-08de37ac3e77
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2025 05:23:25.4865
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E0YmHrGX/Eg/N0A9wAHI9BDQ34dYKBXpbpExTfR61rSY6bl0ENBLbAaAZKdKDtIv9FC/C+UUPm4Di48yCCzRYVOR11WZjgvFwSES4Mrcuh0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR02MB10533
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEwMDA0NCBTYWx0ZWRfX6Qh6ncNpADhh
 fR15z+/BAtSWwiVSzlcO58AWCAjYHUjnaju3U8IxOBFEl58eKylDKvqUKWSTKX2zMMe2jotppU0
 lHKRH3qd48hBZtwZxvwKfIRP80D86Y3NoPO5qAJ/b/mlqw2JLjIGqGCpwQN8FpgFO3OchbwelbU
 NjysS8zKEu5prKjy1bQTENQIxr6BsGG7jqGXLWpemLGgr0yNctKvySyoRZl2qbSvLcopg+SZ625
 SK9XWnzRf+QrMyXNCWGV/N4JlErdgYS0dzFDIRjq2dKgLsemx7C0OTX/yxwqWVL1ulhLyfkm54y
 SuvPnT35n6guHMnGCDhDJ8C9MymhgG40YPk+80HMeIr3I67n9mkEAOnbMdfU80t7yZDy7xR5iNK
 t3wTunpvmgt/+CETFMyapCcc8KG3tA==
X-Proofpoint-ORIG-GUID: 5T-OhNaSyNEv-GHVSeyb4NNJXfah-NA-
X-Authority-Analysis: v=2.4 cv=cLrtc1eN c=1 sm=1 tr=0 ts=693903d2 cx=c_pps
 a=TLRaRVVo73tAgr2tZ40rpQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=kqp_hg9UcqLHr2iSWvkA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: 5T-OhNaSyNEv-GHVSeyb4NNJXfah-NA-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-09_05,2025-12-09_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Subject: Re: [PATCH] target/i386/kvm: Configure proper KVM SEOIB behavior

Hi,

I wanted to follow up on this patch to see if there are any review comments
or feedback. I'm planning to prepare a v2 that addresses the following:

1. Move the SEOIB configuration code from x86-common.c to KVM-specific code
   (kvm_arch_init()).

2. Refactor as per the changes on the KVM side of the patch.

Before proceeding with v2, I have a design question regarding the scope of
the fix:

Currently, the patch sets the SEOIB state for all machine types on new powe=
r-ons
based on the IOAPIC version. This means that any new VM powered on with a
patched QEMU will get the proper SEOIB behavior.

However, I'm wondering if we should instead:
- Define a new machine property (i.e, "seoib-policy") that defines the SEOI=
B=20
  behavior.
- Only enable the new SEOIB behavior in the latest machine type version
  (10.2?), keeping older machine types in QUIRKED mode.

The question is: should new power-ons of *all* machine types set the SEOIB
state automatically, or should we scope this fix to the latest machine type
versions only via a machine property?

I'd appreciate your thoughts on this design decision before I finalise v2.

Regards,
Khushit=

