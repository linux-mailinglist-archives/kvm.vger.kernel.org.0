Return-Path: <kvm+bounces-66594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 77EF6CD81A2
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 06:09:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BF50D3095A0C
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:05:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6375C2F5328;
	Tue, 23 Dec 2025 05:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="12TfU6R1";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="EkTXrjqh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAFF2F90C9;
	Tue, 23 Dec 2025 05:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766466308; cv=fail; b=aofa2Nbt2402xbODQbQPV3h8tZBIxwIG3f1XOmpfKMCkW/dromynhtW8NCPeiTI4fy9zfGCNNnLdC5LqT2laKS2UTMuG4W42ZuTfNK5RbYPQJdo7zNt3O+SxwXO8xCvV7PvgStw36JD/M16dobrPY1hF0Lpd0fTwr9xy+hCcCcM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766466308; c=relaxed/simple;
	bh=/MXgDyT8V5xAixT4CzYhUBHo78I23HjnkPqXDibhNZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cgFpHiTt0/z13xm9u1VMxQ5blaQBNNcU+lIxuq0Z0Ekt5OuP+saA5jsl5OlwxBWakaVGo/s7wmeMrkmClUskr7wXWsSpNivZdEC1KUXIjDxsCR1ulDChl0Grm6evlgWEyJFyqFP7ScnBOvW9dsns8VPoB/+yDvmgh5GtJUYSek4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=12TfU6R1; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=EkTXrjqh; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BMLwnIx3941949;
	Mon, 22 Dec 2025 21:04:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=JTKOnxfafwq5oDZQeRaQrTdKCUCChVYBXSSqe43K7
	hk=; b=12TfU6R180k57HtPdkjC/92k7dAV/J3Eix+xxVwGuumryCXK3HMGWGzLK
	OAjEM+ScuvqruYfsDFC+XVkLUV7rJqde6ZxkGQjQk3X4idYzbv9ZDpcC3PJL/AWj
	8v00oqqrqDUBrk8OYDGuLqofTA347mqUT7470f+6qdGjPfhDyFITsRK0tAnrbyWe
	OcfWwj9hP+x3S6LYXw5mAHeBT/GWiB5pcb/gKO0v7fYLQdRTslIZ9IBtjSO+5b9F
	kNbZczWiG0scnajyO/5bq9G0u0JZ1GA04Gl0Q7xf6b9SmJshZIzGDsycv6wwuWWo
	LXInDuylx4LA//JCDYkN8kPW6Oqow==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11020078.outbound.protection.outlook.com [52.101.61.78])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4b7ecgrr1q-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 21:04:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KNQ9OUMuTsq4QP4/Tr1TDRAieHE13R6ZepWBp5YLGJlBH6flQROuJ7CgzVy3KX8RAWTRbI2TDY+C4eCtsDhf9PVfK/qBoPH4VPyDc+KH+v5fNYF39Vhm8QdTWr7sPt+/O5xZlGBstZ+GzB3kITKZIdUv6146paCmtQRjvQwoyMz8vjSjBoUx7HnPHKgmG1J/asxrQfQP36HrhUz8LfpvNvuFJW0pKiYX/3e9YRAIZZTEfLzOmMY1Ty0tKvBD4bnav8+mgv4dr23JcHyonFaE5nuk6vB+5m+IwbZloD3CQyNBLmWF+O5Klsts1CUvo1aORpswti2kPmdSoqEW0PwTpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JTKOnxfafwq5oDZQeRaQrTdKCUCChVYBXSSqe43K7hk=;
 b=AGGasAxUM8GjI/Vst4BEtV6HVAs7qS9NyHhtBNoc0fS4DoWOKzyj9vOrWWDGrxaLKtB8dD7w/C7FgERx0NkFfv51tBdqEx8FFXSkaW5gkIfqxYutfh8Ulof+ifZpj4PKaYa4trKap9ZdaOhhYFwBZr/fk+VJr9b1WZAkeBnf6MnW0AamWHmalBq4YfYIm14cXni4zgr83AeE5Lowb8zRb/nS1XAoMMrZGd4SToURuiY724OLZbMR4MYNLdpxb23CKbkjRLNCbmFPi+RreDmaMyqcuiPDN+AoeEoUbMRW/imgMb159BNGZrlTVPiI5bu6tLRwZ5UhtI9A9Ln1Zlt1CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JTKOnxfafwq5oDZQeRaQrTdKCUCChVYBXSSqe43K7hk=;
 b=EkTXrjqhGlOV72jDyncPvoCCtv4ye7FSZoeG/5aPKcJyC3xfAhJOgk554b64QqO9UfqqF+UP2k6S3OH/jteNnJWVJ/DuL1RXt5KenmYMCHuYXd6oC1lvCBZBn1pzj22IQdtZJ1kYjt71aIsz1iuWeaZ4LIdgM/zyCpLLlSRXQP1qwStvhaObaJUhepnCjzWLuH67BB7kGLVA2QuPrDJR1IspA7ytQAyIp3k/mSW1jD4bnLDyDNnsAjcDwb2u/ExSvTMEYEQmVNfow51XN2tZZPEX7lfnxg5AiSNUz3IygRCASdQByINJVJUfXNpfY7L6pZ9+UrtGT0i5tuO34gbRLQ==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by SA1PR02MB8560.namprd02.prod.outlook.com
 (2603:10b6:806:1fb::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Tue, 23 Dec
 2025 05:04:38 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 05:04:38 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: ken@codelabs.ch, Alexander.Grest@microsoft.com, chao.gao@intel.com,
        madvenka@linux.microsoft.com, mic@digikod.net, nsaenz@amazon.es,
        tao1.su@linux.intel.com, xiaoyao.li@intel.com, zhao1.liu@intel.com,
        Jon Kohler <jon@nutanix.com>
Subject: [PATCH 8/8] KVM: nVMX: advertise MBEC and setup mmu has_mbec
Date: Mon, 22 Dec 2025 22:48:01 -0700
Message-ID: <20251223054806.1611168-9-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251223054806.1611168-1-jon@nutanix.com>
References: <20251223054806.1611168-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0016.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::19) To LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV0PR02MB11133:EE_|SA1PR02MB8560:EE_
X-MS-Office365-Filtering-Correlation-Id: f4788f76-e338-4b8c-4cf9-08de41e0c5e7
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|1800799024|376014|7416014|366016|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gBdcIDiv2tdOPG/ieMDnLaNjygy40tCp7KfiTJ4q8liElNJxEFBlOc2tjpNG?=
 =?us-ascii?Q?M30eoTcKMtnz3uR8sirHKMamph2NeSnCj9Sc2DFSPm9TiCaHo32eNEKT0yjn?=
 =?us-ascii?Q?/6BodZYc8BYOdvv1RwwE0WKk+LPNM9hxuxyxpXhbieXqZ9RyutnNZCeWpEfd?=
 =?us-ascii?Q?m/OHCqQcVRryWvdv1O0bO+gdlJMyqfwcYGdDCthx4H/UHrrQ8Bbg4vUhiCys?=
 =?us-ascii?Q?qzqrcLDI38p5eY++yU2DPqfQT2NMKvNqve3XsubSnv5Iar+nPJqDQzypw9wH?=
 =?us-ascii?Q?2i4L7JpmjKcvk+sRWtFHLr+GO0t7NHG9etRasw0XyJWnux5w+6aq5z7qtU7P?=
 =?us-ascii?Q?a8zWIWbjTvjMob2XGrqWsvSoMWQCnWssfJ89nRiL8OSHsYyZCfaNvMkm0xoz?=
 =?us-ascii?Q?iB9wyMOgcmNqFXUk/hRn8sxF+Ph5GX9OGd6beC+IKwiw1DGn3nF0v3f4y95K?=
 =?us-ascii?Q?5qG1zSy4Z6PDK4N5na4Qq+uRElxx6B2i01LPEJoGQY6pfcVSILvg1/PZAtTO?=
 =?us-ascii?Q?nQxpDEpTRSosV7BJiIQGwAAJEuPPyzJWrZapex80AkKMfwpn/M8K49Y9MwoF?=
 =?us-ascii?Q?XHlD8bJdrIiUtB3b+hkJ3a2h6LDhoCU8Orr9rpkPAUpDp63UjMqU0tpUyymG?=
 =?us-ascii?Q?eKznpOfUg9OPgHPyY6pcrKO95SxMvJIqYYSAZh57er9QSprTEh0WQa1XFJTJ?=
 =?us-ascii?Q?3xV+fzfzUSMfqSU9+P9X7pIErFzyHLqQxfHDkrHT8Wu5EXJnsRpuvNodBqPk?=
 =?us-ascii?Q?Slzu38dR3JhOXa5SzLs8pYMrORhBJr/ffOOrrmcOmRExwIsE88bp89e34Rmw?=
 =?us-ascii?Q?H22ULPzbaRoS+Axyp035hs/GTG3mzzTTwNzYm5onaBEZJZku2X2GFqJcM9Pz?=
 =?us-ascii?Q?4ER7fBUL+nXI6S1ryjVl5EmJoJ3+Q16HZT0HPsVpYOI03QmoXnMLvfZU1OaO?=
 =?us-ascii?Q?UfN57yf269GMupypG8we8kuOA3aPq6Pu1VmJIjk+zs7yQXZcqemcsP1btIN7?=
 =?us-ascii?Q?3Fc+kL6Q89z5UFOv/kfblrClMGJhDdOAC68skRMtwZuVXZDLw9SlwISeX1t+?=
 =?us-ascii?Q?xdcsb37hR5bhHML3ezsxm6RBav8IVjdUBQBGhms1yT4c2L+G4dTO+xjtk27K?=
 =?us-ascii?Q?XdIHa7ZcMRWu9n/5UaL9oehbGffuA72lMM3kQCrgoyGHrbzcl3ilohYhhONt?=
 =?us-ascii?Q?Ct8y87w5AyCRs2nd5xiLADudOdeupsVYSZYlmY7ivTcCGHZHxDRiftZP3U0U?=
 =?us-ascii?Q?DXO3fbrpihNM38gpZA/biGxbiYYdVtEYI7/2QHCP15oOMD6WK9h7Cg7PFSBa?=
 =?us-ascii?Q?T4qv/aDLPpLT7jyOd8wbgAK+fGEz5DcaF++lMXepJqJhQ8AOnFsyQdbhI0zD?=
 =?us-ascii?Q?FFIv8i7fAoC3DuJhTMmaHrfHzImmSFWdv0V9iaK5PdkEzEpTXu/6Vr9T+l+G?=
 =?us-ascii?Q?IF2c9+KunRbgSTIYbQbpSAt4uESrFsnZfpgqc3RUi6vsqPoBReX9FW2hL6jY?=
 =?us-ascii?Q?E/NeUcKOa6/tjGv0Ua02eRqzGCbcS7OKaoncmJ4ZPUBF/kIdM6ZtG5YrYg?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(1800799024)(376014)(7416014)(366016)(921020)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wZkNN1zGxoWbcGI+9y0t3crgiSytG5h8FpQTtmAf+I2jaaSyvg/Ord4fQgCY?=
 =?us-ascii?Q?+1gA/ni3JMCIUVvdzwhT1IlEDaRm4LeDKqcRU2oIswUrJtnIEVVuqa7OJhVi?=
 =?us-ascii?Q?4lI14Ze0AilbFoNr068Qv2HRpVV/9LcUuyeD6ePquQLNd2VzMysSr+10YsOO?=
 =?us-ascii?Q?wlbadqqQKOZHthyssOTcxSEo+fbw3Gb97YEOsqrRiIPnrbSFr2ki3VEOLBH3?=
 =?us-ascii?Q?vKQKSJm5SwBRXBzZl8yG96mL2TNHd/FZnf+1H3TEiJtsULS5PD1lzy39ygap?=
 =?us-ascii?Q?OuG33aZSWaub4Hp7RPWTTalxzKkc11Q2E61yOe3b7NsEJZIJ+nEoaCjzcFpa?=
 =?us-ascii?Q?CSNkHhBB69mEDShdTrvA1dWSRqgnMBxOKSJhLxWvaiDU3MIxWeQ+J665oUmd?=
 =?us-ascii?Q?K+KEAxprb7WoQV1d9o6SDhQJ/8CosvvRLBKKEMgXxdcjbBMldACYx3xg7yxf?=
 =?us-ascii?Q?T60PGsjWDRqo+w4cYkANIFZ+azIHtgjo4Ni3xzSmG/tWkgrL8exQAvUpGnhV?=
 =?us-ascii?Q?lacjLBLdP3D0vZIYLzdM6WtzYy2CLPsq8wN0+8SmruQyByR3YNSn/iNTx8H+?=
 =?us-ascii?Q?g2CvQkD/1DotzzqBep4PPayNR81S097BJBhx1y9d2Fut7s5DDxR1AhbSDkb5?=
 =?us-ascii?Q?kS/z1/lRBdZsVsgTfAzYrzVXLk0JVpjAjP5Yas3UX5TbVgWzEIIfeCbh2bBD?=
 =?us-ascii?Q?xOP/kmXg/pIJSFwUuTKnTaK8c5IIh9c7cv6vGeMUGTDUqrQVVFr3Dksb0f10?=
 =?us-ascii?Q?fBy2cmN7/1A5r39IE7nQgkVUKWs516kSst3NhwBMvEMvcDq7UD/Svzs8AOa8?=
 =?us-ascii?Q?8DRszMFZj3JxsY+jTjSLQt4NwUTjZV5ReyWKEQ+A0Uywskwy+ulioRvCsBuV?=
 =?us-ascii?Q?H9WrmGJF38/NfbZLMQlcT0poxq54GOn2I4buguRxRbCkP4f+GKxE0NVyXDiP?=
 =?us-ascii?Q?5OR0FA/cl3KyhjPDs9etkITNH7T6ZcSHvbZLLmOLtRchsjdFYKa6vlAjgapi?=
 =?us-ascii?Q?WbZyl9KuDNKsKeUyxiDjJ/Rbb1MluCo68l2Ixs83zLBWcQ2l1BmxdQdrL+72?=
 =?us-ascii?Q?TH2kh31OgbVaSpZA4BUD4uhS/A0nS5kEjeCRHVfFRONgvQ5wAgNaM5j/6DAN?=
 =?us-ascii?Q?bCGilvXLUm8gqAoDqEQ1/OX1N1Ssdpaq2f9GbnxJTHPNCkPVAaisrYcatPU9?=
 =?us-ascii?Q?2UronFEiX6nv2UCShgFwtQntsnlgFUfEPx3IMsljb/qffVCWx2V1niu74q3Y?=
 =?us-ascii?Q?5GQvCl4qtxW+73k5EVshW6OxQLmZarX2/0+zdI3udxVN8uyQ5sHbbtPaDNQN?=
 =?us-ascii?Q?kFH5MRK6PKg3mfArj/4NbaWgtJH3jA6JBW8c0kJswfg6zoqRCQAbMEVZ160+?=
 =?us-ascii?Q?8fjyILfVJu7fXOHCuMYAzm4B19bxZ6pV8Atp+QOu+KfUQiDVdjAIEGlVNj+b?=
 =?us-ascii?Q?h1Uu4ZQolcQkH84WoY0yeT3HWr9XsoGJ4jljR5F649yMxLQdNAsF5YD/9rHL?=
 =?us-ascii?Q?hl34GmAdDK3a/8p7Mv8bo62cQyZhVh14Fgv1PCW+dXBLk1512gKNyXTYrScY?=
 =?us-ascii?Q?yfreNoWN3WatQZVPSEsI4dC/OnYtvs+UELvrKmM61h6hiJPadKknuvroO9uN?=
 =?us-ascii?Q?vfeGiS6ZSD5RNovgjlzPvvvx3Z7ewJI7wr+2lDLdmsr7bQ9FqTzROq3I0Evb?=
 =?us-ascii?Q?Po/zMVhF9+nqOPNQIyDoreDJ9ASkf1UjzVb0Jakvae1rNT/CkbfksenU1OXe?=
 =?us-ascii?Q?xiNHi9v+M2bsklaFVX1TpmqTCEDUtxA=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4788f76-e338-4b8c-4cf9-08de41e0c5e7
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2025 05:04:38.2499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kuJmmROQ3yZ6Ol2ur7EgWOxCb4WGzQadV36bPdy8xgnWsvWN2feSIcAiNJh/J+zGAs44nEvWhh38Q7DtsWscID+4hiJKLSFxpTFRj5l5pDE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8560
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDA0MCBTYWx0ZWRfX4n3PTo5RKwUU
 LHVSYEgAZnwfQqe2ucQM670cDaHpViF7CZzHjQD7q88+fvzVrDIss2Qxj1TF4BQt5oBAb4VdMPf
 Vwz4c1rkZLPSmtboidbK/ucDuTY3ZJ9j/JGpLIT7xL8/gTal8DEdemhWEPx7re5w9v8aABSG9Ab
 zWQye30U189wlF2WZiAjoUEgiw8eN0/4j0XwhYjfbRb/EkTdLbI5YTDNYWgCB+CTkJkUG0kPw++
 oP+tYyKj8NeO8WOro89AVdq90hBVxliQ+qtsTH99QuCfgFPvEwe4ytiTmEVizHUPd00WjCHVPFp
 boZbf0IgMz0mEpEHhdY0bAkN29sbo85Fr/VA7fvvOu4ai6gM7k3PhqThPoRs3vS3sp1JkGCfeET
 8VlBCzICDPYpiagGJ4t5qaUoAX7g0i9Z51lqXTdUjIcOBmbpzWUnGcvG9OvlqHp1BBXmTlUv44x
 JUIVw2uSpBRg0HnMNvw==
X-Proofpoint-ORIG-GUID: JA1fzyXWR8H70KQI3FNSjsEdt5Jx4Fe3
X-Proofpoint-GUID: JA1fzyXWR8H70KQI3FNSjsEdt5Jx4Fe3
X-Authority-Analysis: v=2.4 cv=R7YO2NRX c=1 sm=1 tr=0 ts=694a22e7 cx=c_pps
 a=qgEGzIGkZH4qQFF7vfwnSQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=64Cc0HZtAAAA:8 a=5b0qK6K-TFpaBXZJLVYA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Add SECONDARY_EXEC_MODE_BASED_EPT_EXEC as optional secondary execution
control bit; however, this is not used by L1 VM's, so filter out this
similar to how VMFUNC is treated.

Advertise SECONDARY_EXEC_MODE_BASED_EPT_EXEC (MBEC) to userspace, which
allows userspace to expose and advertise the feature to the guest.

When MBEC is enabled by userspace, configure mmu root_role has_mbec.

Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 arch/x86/kvm/vmx/nested.c | 6 ++++++
 arch/x86/kvm/vmx/vmx.c    | 7 +++++++
 arch/x86/kvm/vmx/vmx.h    | 1 +
 3 files changed, 14 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bcea087b642f..ca1f548e0703 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -474,6 +474,7 @@ static void nested_ept_new_eptp(struct kvm_vcpu *vcpu)
 
 static void nested_ept_init_mmu_context(struct kvm_vcpu *vcpu)
 {
+	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	WARN_ON(mmu_is_nested(vcpu));
 
 	vcpu->arch.mmu = &vcpu->arch.guest_mmu;
@@ -483,6 +484,8 @@ static void nested_ept_init_mmu_context(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu->get_pdptr         = kvm_pdptr_read;
 
 	vcpu->arch.walk_mmu              = &vcpu->arch.nested_mmu;
+	if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_MODE_BASED_EPT_EXEC))
+		vcpu->arch.mmu->root_role.has_mbec = true;
 }
 
 static void nested_ept_uninit_mmu_context(struct kvm_vcpu *vcpu)
@@ -7313,6 +7316,9 @@ static void nested_vmx_setup_secondary_ctls(u32 ept_caps,
 			msrs->ept_caps |= VMX_EPT_AD_BIT;
 		}
 
+		if (cpu_has_vmx_mode_based_ept_exec())
+			msrs->secondary_ctls_high |=
+				SECONDARY_EXEC_MODE_BASED_EPT_EXEC;
 		/*
 		 * Advertise EPTP switching irrespective of hardware support,
 		 * KVM emulates it in software so long as VMFUNC is supported.
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 520ccca27502..e23e4ffdc1b8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2682,6 +2682,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			return -EIO;
 
 		vmx_cap->ept = 0;
+		_cpu_based_2nd_exec_control &= ~SECONDARY_EXEC_MODE_BASED_EPT_EXEC;
 		_cpu_based_2nd_exec_control &= ~SECONDARY_EXEC_EPT_VIOLATION_VE;
 	}
 	if (!(_cpu_based_2nd_exec_control & SECONDARY_EXEC_ENABLE_VPID) &&
@@ -4610,6 +4611,12 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 	 */
 	exec_control &= ~SECONDARY_EXEC_ENABLE_VMFUNC;
 
+	/*
+	 * KVM doesn't support mode-based EPT execute control for L1, but the
+	 * capability is advertised to L1 guests so they can use it for L2.
+	 */
+	exec_control &= ~SECONDARY_EXEC_MODE_BASED_EPT_EXEC;
+
 	/* SECONDARY_EXEC_DESC is enabled/disabled on writes to CR4.UMIP,
 	 * in vmx_set_cr4.  */
 	exec_control &= ~SECONDARY_EXEC_DESC;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index bb3d96b620b1..ef45e0ca0bb8 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -584,6 +584,7 @@ static inline u8 vmx_get_rvi(void)
 	 SECONDARY_EXEC_ENABLE_VMFUNC |					\
 	 SECONDARY_EXEC_BUS_LOCK_DETECTION |				\
 	 SECONDARY_EXEC_NOTIFY_VM_EXITING |				\
+	 SECONDARY_EXEC_MODE_BASED_EPT_EXEC |				\
 	 SECONDARY_EXEC_ENCLS_EXITING |					\
 	 SECONDARY_EXEC_EPT_VIOLATION_VE)
 
-- 
2.43.0


