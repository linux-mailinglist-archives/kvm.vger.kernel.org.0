Return-Path: <kvm+bounces-32450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FFEA9D888E
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 15:56:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 77561B64F25
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 14:28:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 259F51B3923;
	Mon, 25 Nov 2024 14:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M36e36TE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="j5GK+Mm7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F98C1AF0DA
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 14:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732544864; cv=fail; b=BPuTndZM08lpT9N8uubzmrxUhIsVqDokjDobb+0Z4mesANsb1GC41gVrFGFU8J0utuwCmAeTDrJbTD0js4VIe6nYOgVCpunLJ+5s2zof6pnUwRcd+VeJ186Dp1k3foKvd3qgZh2MIuXOvdteQhlPV7uYlyhDg1QF9Wno1IiQ1CQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732544864; c=relaxed/simple;
	bh=iAii8oWtUMw971GVK66NGxf/T+iHgmSHkPQXXUA1A/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=j8iVOnRkGEe/EhG1I9jlwqS5yunftHNX7O8ORJh9cq7gv/ulMQgn1Vf238eD/J52Vx0OmA2YQc5n4SQxLevQ/mCtiIH8ir8XcGDKpGH8RA2mD9yCq6oL28NTcDXMUM/ZS5XJuearRLPm6+kBiCbMB+z6dGrp06WHpN2buLNGIp4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=M36e36TE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=j5GK+Mm7; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AP6feOO013084;
	Mon, 25 Nov 2024 14:27:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=vteplBxtLrG+J86puz+nqt8Ab/wYSNv62AD6jJgg5CM=; b=
	M36e36TE4XhJQA3uTf3PDDGXIM/kGSu5sf3kVDLJaT39TUmT8w7Yh0U50okpq+/2
	dYTpAEiamBHfjeZDk98ah+Ht6Jkr/STwMR7oOLUKEe63jvYwJACtyatb20gPpgHm
	tIzpFuOWNtXvxjWRk3M8duloX/xv+5lzDdLk6OBRt2+SJAytrquvknKlDIXBGFxt
	qRp7GV/f1HIlxo1cmrPDc4rKk4o3PlKCncyND+DPgwKfA1r4c0MvBdTKuwIB43GL
	RiAornLkHodmEZQldUf7/IIZ0EAvqULvNZXUxh/2HfXv2dTMgudOnGFVLo9givHh
	Jz+ZX89kmVozmG+prxv7fQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 433874b7dc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Nov 2024 14:27:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4APE8bJA023429;
	Mon, 25 Nov 2024 14:27:29 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4335g7k1m7-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Nov 2024 14:27:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xcywp1XbSVGnabRlerO+tt/HpshmpSfk8rUnA9LEA40IpIn9uuOYQt4JyFmsrNXnGRBtUqli4QbsKRPv/X15lBXKVywT3eQ1xRc+jSlGzwt7CfoHG+6dhTHSEXF0csOvOFtpvGQmnLOYuo0gP9UXOQZxPmS11Y/AB+v/AkAgfV/Ed/iOIXmRbb5t6qzQ+EL+4hNX8MI+n/fHieQTHq6cIj9vXGmPBuvucqBhcN8bl7k4e5TeMxr48M3t8UYV/XtRBVI/WGxG0OQCMrKmmrwjG6AxzLg6bOHfGm45ZjahR4N7u7YdInRGYBq6uQTzX3DN3/iDz9z8OVw0mEm89GP13w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vteplBxtLrG+J86puz+nqt8Ab/wYSNv62AD6jJgg5CM=;
 b=MLgEAuPnVmlH+NvdhdsMCncgfg/O9434rQquiQaviTvMJtCZ/ZSNntrVJi1KcuL6+q53Y3p3hqBpVMmN+/aNgAJOKCmwe2nyW0JflcJIeL+04RZ7Pq6gRjoY30MQwdg3i6GaYEYt8Uxd6JBD7S5RkNbxeWXXTE0PFBDbMiXE0BK1+VuK6RIVKJnUVuq4z9h0v/sFWCWO8c85g+3XdeX3403b/kRMKzba7BLVT+ys2bWuDx6ucwbFVsdOOaP9nOs89l8ICkfNGpkD3V0SkKoMMDMbHmxVSvBNooeUQWhkeOI93ET1jhJuC6vBdeXj4q+bwhyoPY3XgsBk4CKQJslTqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vteplBxtLrG+J86puz+nqt8Ab/wYSNv62AD6jJgg5CM=;
 b=j5GK+Mm7D1jvU4KOk3ZNvBvKfWfXiE5rF2TAu9ps5IUXKJBeS9qDjrT2j0SGcMYsxIpL6H2VKMDI7PqtygP42iT31rjaZqzypzXYDim9x+O9WRSj3kKSJWMAH4oQ5frz2pzzfpmNWtnAQAwwhV9rw24/dO/dk1qtF20MPifaJ0E=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA1PR10MB5995.namprd10.prod.outlook.com (2603:10b6:208:3ed::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.21; Mon, 25 Nov
 2024 14:27:27 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%4]) with mapi id 15.20.8182.018; Mon, 25 Nov 2024
 14:27:26 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v3 4/7] numa: Introduce and use ram_block_notify_remap()
Date: Mon, 25 Nov 2024 14:27:15 +0000
Message-ID: <20241125142718.3373203-5-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241125142718.3373203-1-william.roche@oracle.com>
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20241125142718.3373203-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CY5PR13CA0039.namprd13.prod.outlook.com
 (2603:10b6:930:11::25) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA1PR10MB5995:EE_
X-MS-Office365-Filtering-Correlation-Id: 83b7c7b6-6800-4950-4b87-08dd0d5d4925
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QL3NIns36iE5yjJnyYmNaXzh6cCYA4VaDFnEkk9llGgld/68saau1cam7tyc?=
 =?us-ascii?Q?dY+1W/JAdDfFIoZi59++mlehIjPleo/Eya5zn70X9bIdodOV6bTsOTeGFRju?=
 =?us-ascii?Q?CVuwp49wF4rRtgIfHlXlyEkwNSbvOxhFOeUtU/1vIkG1yqr7YdnttmruGSLM?=
 =?us-ascii?Q?j2qvcrRf+NxXF9TRw2pII2pjirFSuPUHL+pPyazGCS0B5V8MnCCbBBjNdclV?=
 =?us-ascii?Q?mK+KjElk5uv6QmUapsI86LlPMUAkRdqV95CHvQjoZ9YV5rQTRn4qY9CGUJKf?=
 =?us-ascii?Q?xAgTBIJ88z7nf2zO6NO0CpTqC/StOg8X0966vRmscnsCUKqJVvmPA45KN0jp?=
 =?us-ascii?Q?g5JnneZtWdun5YuQbyZ7vWgRskHsMRNcmwVKObLctMGzQGvXfY5fg7YMDnb9?=
 =?us-ascii?Q?NjwvbzzRU+8z4QbtvTBRkP6o7JlSkerCUynPNI0Lo67Br2LMLOtZU2ZTyCgw?=
 =?us-ascii?Q?SjYOpJboxQWoxdUPuIEeYMlHpSwNuCVvxdES6AJk0B/PSEfl/nXKK0o3tpEe?=
 =?us-ascii?Q?qcOPGy4FjTGMjT/GH4XzC5AOhFtYn4gMtx82tYVlNTQ/1BOQNWetx0AaymIj?=
 =?us-ascii?Q?csYQPa8UACcPTAWUHtLSIfGE0lrMxCknG4SoZlh6uRlylS9TauZyb/D12l+B?=
 =?us-ascii?Q?7LxZP18iNno5vLuVwAPIqERrW8/r06DGS5D2aRN3bZdBFFGh7XDRl3yOZiJN?=
 =?us-ascii?Q?HR12ZXFHoYD3F2YuBvnrUw3UI6e0mQBjoMUG8IeoxZKjMmTyYdUnRQU4x0gs?=
 =?us-ascii?Q?7uN+jSb9B3KWIkHxPk1OJZC+GIENSmpbXzZzIR8AKdAiNb1ZQC2uGlRBxq+G?=
 =?us-ascii?Q?hLAFZ3qbB5IxDGsEoAlaOq2q3DQiShXcJ+YsBuc58RRdFwjdI0NNeIRrTL5D?=
 =?us-ascii?Q?CKY1YTvyGp5HmDvYcCmLTjUHJJtXs4E5avjRQfu2bSeLmkIdV4eQRmbwTY05?=
 =?us-ascii?Q?2d6jfe3jnVtbDVyW6TbjmIDahb1SAXGbUeJz7kdasN77EJ2A0m2lnkaH4AEY?=
 =?us-ascii?Q?NpeZGyIqw3aqQBmDpcw6z3nd5q2GLBHTcc4UNt6ZroB+gsjLb0eYh31Nls3/?=
 =?us-ascii?Q?Yo7VFStFxjAvgNsc4j51MQelyMK7yN1DQvqBJ8zo2psbi7ygFz4xURL6Dqgh?=
 =?us-ascii?Q?vQ0qxg5ngHvbBTpX4jnSbg5oJuW3SqwipgOSJg5PMGyiPuJTJpgyFpmYuOie?=
 =?us-ascii?Q?OGn1edZuBMkT7kRBZl/pY0KyyYXnvX3XkxozZsZQMeFW1Ej5hLJAs/hCP3wL?=
 =?us-ascii?Q?W5lYC+B1UvwcdELV6lJ9uBGIWTmit0r2w9RhDJ1Gs3yI+CEfNMvbL6MU7Cv/?=
 =?us-ascii?Q?iMjTtlNt+wWukF426qYkWvQfxtksTU2WOkHO0NlpWvZw5g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9PKDDjR4ZNdJ+g1k1vEIsFifSJqqR7swJ8QghGJSh7xRMC0yv16U08yagZaz?=
 =?us-ascii?Q?ixTzaFidpQ2JwXLz0xPBDGy9tusNEwVZiuBVEyC44K4Y4uQZ0npOVff6g+/D?=
 =?us-ascii?Q?tFs3JJObDzIyg8QbPmkpnZkSqnxzk7Ya6/R2yHcFZObx8H+WsHNCaKaajK1m?=
 =?us-ascii?Q?isA7jkgDPEBx5Fq++NKaUSKqIuXnqeKyxxJ3ALQzpKbX21YXhe5fwdUiNSR7?=
 =?us-ascii?Q?ljCx2KkA4tyTN1JHSDIb+cZr68ygxLT41GkwCnhtOdNQKNQuAsKVbep7FjZ6?=
 =?us-ascii?Q?ha0O40eNPr1E3KvOXx+mm8fpeHtnGcSw7KfPGeV/Ra01otKTfTlnb3Evwc7D?=
 =?us-ascii?Q?qizjpBUohhRDmZQAtY8J5mJ1GWKhueGuD4s7WpXVZhTs36QlBCu/vu5eo7u3?=
 =?us-ascii?Q?M65VS9LrRf1rx8AJ2ZDAOdJFdLuHWMcTGWUrHM1mrqZi6HhBnPiQCl12jQq9?=
 =?us-ascii?Q?qzbt2qvRqOeI9FJCLHm64D8s1OBV86/8Vsgdv3+CKJpc+AwH0Eo1vsOwJ935?=
 =?us-ascii?Q?tvKOrOlkqdskKDTaantPOzJ8SdiEXw57M/qKmkk4w+EHi9J5zdhpyCbn42Kk?=
 =?us-ascii?Q?OCgMAIFNlM9ax+oNa1YZV2DbJflAzEzFhVQ7LZY2vEJSFHUD5zCvfvDwg4hl?=
 =?us-ascii?Q?5MrrayZjKIVivm9A+Ltmejz37xIMh98UxyTaC8bMozdk51QugyOwbDFG4RpR?=
 =?us-ascii?Q?IY9XWcp+AC0fMotpPyMla/8BJbBntLnrCRda14nj+StgGR5yT0JLbSA1eE5R?=
 =?us-ascii?Q?4EDUHysqKZzC3uZlT11AEdHac3hcQaw/kcNvf4CuTYe812gsfuhwZ/Xf9FXm?=
 =?us-ascii?Q?sioP/ksUCi58pvAsa6vAnqkZQawiy1VPxdzTRfQskQ00gSrpaBoNildL513h?=
 =?us-ascii?Q?NcLlE0TpxG1ukFhVwsC4oYhYsC6qbYyrxqi2WlVWg8FWd7HJHObZbrn/cdCR?=
 =?us-ascii?Q?Tcwbk0usUeZ9vPnqOAbQs+mLALmO5NHqKC/ZPaQ5L+sZq9wRQFSfvW1s+3gD?=
 =?us-ascii?Q?kv781JWrLiPM09wHnUPSoD0TtR8DVx8T1tvSrmFGEZc43ECM7eMH/HzKhR17?=
 =?us-ascii?Q?fBcnytK7zmDId2b4LIU28Tj8W8x+XLugKnGST+m10/t08g3ZFAXcVn+q4/Np?=
 =?us-ascii?Q?vzea9b+W4KJad85GLqND7X0G82S1r98OU4Gtp7qHybDkyFRNUnBY2J53U/UW?=
 =?us-ascii?Q?cUXDp2ycgA3v8RCD3SzyuPG+44I9OJiEaKXlcdEwZ4WsXDLJI26zLtdjwKuL?=
 =?us-ascii?Q?M+TiPrqC6xlDy61EMmcniHChwh6+CfDhSuxXIfRlexeQdhferqUhUwGWWiQM?=
 =?us-ascii?Q?mVklFbDtAIZ0KpnWmDe2PHcMCCV2OuNNjxGk+TucTDjjAerNbZ8UAosMpuHo?=
 =?us-ascii?Q?5ZEGa+I1Swax4AHMDLzjC7mPXOVSh/3AxvgEOP7lG6lVvnUa3xa4S/DFoIK8?=
 =?us-ascii?Q?jseGljMxRUlhmb3f5P7SX6o1AKYqz4rmG4CE5ROKGXaQCIAbMfpbkDrz4rVg?=
 =?us-ascii?Q?TiZ46LC0NKyRvZxg8pwBNNrfi+AglOKx+65NUaFqUQU916/MYCJUfUEqNOkT?=
 =?us-ascii?Q?Tc7Ud7u77yu4ugjJ+I5YanvfS10ti7ZG2bfqWye9R7nBoqeEXDg41ZWaoPed?=
 =?us-ascii?Q?hA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WIYh6ERbBH1D5o5jP+xupxCirFdUtmHBRTlE/RyQMlCncMEh5J295ya+E9wpeOE7PEOE39RzSdHppmC5UulJEUXFEPjWxElAG92RXBFCNQq6KYJkhP7ftSy0a+KlJsJbbrJiVNxU00t3krhaU11IaNtSde0Bsp+vtQ6cGfmye112W3txoDYyGHh8bcZ5onq+VtFPf3IDcxoVg3TQVRX7LwM/m8i1sGSfPdnaHDXGqjQkx9OhNo6W3VfqkDjvB2NBOkQb+LBQq0d9QbyQXLqCUul3/1qJzxqKt/TsP1/Pafa5EbQ9SjkLTjSJtKdHmWaNB/F206YL+0HQjS084S9tj85N4CcWytlC7DwiQ1n2RzbvnsNlWgDD0jNAP7sZF5lIcx4mQtqeUBsdHI7pGcd42P6P633tg4eLVBskLFc0DkpStYoEv+R6an5BLKWVZAkTiWYUt0kn3FAS+vE66qn/XlPA5ei5Mz0jM4gyzSca2ya2IfIZPUSpgSUVszahyqM76iZWxHyHLC7C2CNUC0Ui2K42AUvKBp2DUozURKDtJbfABUfewDWkVY7VQay7MbrdRmt4uPjPmZeoHjQ7LLvJvgfr/ZCxyyyBksFCZH8WhVw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83b7c7b6-6800-4950-4b87-08dd0d5d4925
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2024 14:27:26.8512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4F8dUvMe/cjnrY9JVrxe+e4JDAo7L4f2+euXFzqQIcS2tbxylMrsdjR8ILWUMcq3uN6bFznX/MV+RXRlEyCQZW3fUFk+gu7S7rWFwsffDhw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5995
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-25_09,2024-11-25_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411250122
X-Proofpoint-GUID: o4QnDdn5jyZJMLYAcntfkbGVCsqek2W-
X-Proofpoint-ORIG-GUID: o4QnDdn5jyZJMLYAcntfkbGVCsqek2W-

From: David Hildenbrand <david@redhat.com>

Notify registered listeners about the remap at the end of
qemu_ram_remap() so e.g., a memory backend can re-apply its
settings correctly.

Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: William Roche <william.roche@oracle.com>
---
 hw/core/numa.c         | 11 +++++++++++
 include/exec/ramlist.h |  3 +++
 system/physmem.c       |  1 +
 3 files changed, 15 insertions(+)

diff --git a/hw/core/numa.c b/hw/core/numa.c
index 1b5f44baea..4ca67db483 100644
--- a/hw/core/numa.c
+++ b/hw/core/numa.c
@@ -895,3 +895,14 @@ void ram_block_notify_resize(void *host, size_t old_size, size_t new_size)
         }
     }
 }
+
+void ram_block_notify_remap(void *host, size_t offset, size_t size)
+{
+    RAMBlockNotifier *notifier;
+
+    QLIST_FOREACH(notifier, &ram_list.ramblock_notifiers, next) {
+        if (notifier->ram_block_remapped) {
+            notifier->ram_block_remapped(notifier, host, offset, size);
+        }
+    }
+}
diff --git a/include/exec/ramlist.h b/include/exec/ramlist.h
index d9cfe530be..c1dc785a57 100644
--- a/include/exec/ramlist.h
+++ b/include/exec/ramlist.h
@@ -72,6 +72,8 @@ struct RAMBlockNotifier {
                               size_t max_size);
     void (*ram_block_resized)(RAMBlockNotifier *n, void *host, size_t old_size,
                               size_t new_size);
+    void (*ram_block_remapped)(RAMBlockNotifier *n, void *host, size_t offset,
+                               size_t size);
     QLIST_ENTRY(RAMBlockNotifier) next;
 };
 
@@ -80,6 +82,7 @@ void ram_block_notifier_remove(RAMBlockNotifier *n);
 void ram_block_notify_add(void *host, size_t size, size_t max_size);
 void ram_block_notify_remove(void *host, size_t size, size_t max_size);
 void ram_block_notify_resize(void *host, size_t old_size, size_t new_size);
+void ram_block_notify_remap(void *host, size_t offset, size_t size);
 
 GString *ram_block_format(void);
 
diff --git a/system/physmem.c b/system/physmem.c
index b8daf42d20..6b948c0a88 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -2246,6 +2246,7 @@ void qemu_ram_remap(ram_addr_t addr)
                     memory_try_enable_merging(vaddr, page_size);
                     qemu_ram_setup_dump(vaddr, page_size);
                 }
+                ram_block_notify_remap(block->host, offset, page_size);
             }
 
             break;
-- 
2.43.5


