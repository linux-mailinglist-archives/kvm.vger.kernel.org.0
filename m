Return-Path: <kvm+bounces-57757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAD9EB59E12
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 18:46:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A8362A4C98
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 16:46:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F7523016E1;
	Tue, 16 Sep 2025 16:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="GpAvCi5D";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="QnWH5JeY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B80F371E96
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 16:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758041108; cv=fail; b=vBGfukCzOSi4dy9Q+VdtvQ6/g3Mrjt3AT1mb2Ie0PQKrA3P9VAvE9lA1efWwo3tTYsIIR1/WEVTYIJGGINSnaXXgcYxbskzO4VJlwOetwSOawvRQTaB7KsAYZv+NrTUnGJSZ+MiKvesQdzgz2T52uIuHkXaTMwUJ4ky7SGljcb4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758041108; c=relaxed/simple;
	bh=T05lPWBrhfW2BufyuWr3TTtmW4S6hI71MRB8m1Fj2Io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QRHEKm+hCT+RJ5X/1wv5SSt4zolWpgOLyZyx0HNfIBnORYul2aYH1nzameeaxRMtX1xBRv9UQHplqTkDouUu/9DWvWdvW59rNlK0gwRRgCtpI61JMjguoqHPBUB5K+BoeV5D0vH7PP7efqwrsp4enhsoow77ynilz865PdCAToQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=GpAvCi5D; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=QnWH5JeY; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58GBksYV1385361;
	Tue, 16 Sep 2025 09:45:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=sfu5ztQNoCG//0SOboBs7Y+4AjgGXKmnQ1T4/wbG7
	b8=; b=GpAvCi5D0wAOHjpicxfttHiK6Srj6foT0Q1PaeG6zEXNqw+0ojw0Hip0a
	G9lvMtlJ4ZJmnA5IaCMeMRn268PLIBuvqhwFweV57csq5VaiTuv9aAAPUT1DgWOu
	vpAr9iN1QnJPfJTPFJsWBMYnbPoIytCRgbLVs1fkCDL7Cef+O9DIx4WgJhz+R1fa
	jSrq/K6BEu4QXeGbPJRkchtT+ofDBdQY8f5ObsgvzgqrLrvOQkPYqLlvasCwEFrF
	97jz+2r9UQUX9gr5CXFFXpmN8TGeK0OhuFsyInW2J5rlI72hx4hvblYF/dPj0oVc
	PTm0Qye9UqAj2sc2fJDcsFUZ4Wkzw==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11023126.outbound.protection.outlook.com [40.107.201.126])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4977angqep-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 09:45:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jn5fKXiCXIJEy+As13fuox3Usl0XJG+qSCFjXXtsJRrpVrCxMh4qOzbWRzmKMorj37ghI8q49Esi9ajTw+lFwS0FQ5GOORHlWwhQcmlq5UWlldzDKymzBvSGze0TPFlocauwfQJSSSef1W8hIvKeWU3fQkelZFVF4vrIMW7Mmsh5V5oii1ZvOMFq+yF3ENRhQEPIHoAk+ThG/Ul3499d9JfjjOAEl9qlhzuRGrYPMGkXcvRoBNHTnZjU52tWLu2J2hZy+jEcuAfgT49vUB36uIhCufJ9xukEA7YvWaKugxQs7aNRU33vrUsuDBAUnWCgH+7PKbL02BUHhChnfbSKcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sfu5ztQNoCG//0SOboBs7Y+4AjgGXKmnQ1T4/wbG7b8=;
 b=wV3LXuSozHo03mNDxvYRiiMsACJo8e6E6pnSdo/gXfim1tN6lAhf6qW2iodkp8BdEXBVyqUzK6yUmiIlPcEHBZYmgpFrSje0aUWFwti3NxtyaHI+2IOdZrFqnQHd3v44YhmwahLy4IdG9GB0c0hn+p0AbdLTfO44ZJ7c/PuknFrDXQM3AgUmhgCAEsD5u7vnG/mPbHGRomxVwMoGQ81GoO4DZGhylJPX5qL/fwksoHclr0ffAHxsDTbaJz7ZGkX6cn0XoOie+hP4ZxxMnQtpkcHKoytAtb/Eh13X7v0J3WYnST5NujxqwLj7uKWNc2GAfrKm5Sa7+gXMkzPQ9Z0Emw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sfu5ztQNoCG//0SOboBs7Y+4AjgGXKmnQ1T4/wbG7b8=;
 b=QnWH5JeYKpeuQ2kENvht8pEJysnuuqcpmNIwg8VJxrVrefo5G/FaSkXsvWD6PdNmvUDggr4/1EZmFtMrj3VJ1XFlD/sLtvC1fTZrNTSSNr2s3gYrOyuGQt2Im4KqPgRCailrwX/f/Zo+FRAuQsZjJB2kip2Pyl8r4nkVQ+nNftWPbFI1DXU95SAJc4CKd4twE0TQ9nrZHfVPrLqZe+F4H8VhQdT7e6KzRjeYj583p3tHaIZlkJkekcvwnF4jpYNGmXIA6UT0leVFvcgIqNDqqFJ0GCEuIs8b2osv/1d/9jVRZBRZtjlLab9n4KqSqQH/a+A675bbtw+bLHa+gV3UJw==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by DS0PR02MB9620.namprd02.prod.outlook.com
 (2603:10b6:8:f7::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 16:44:51 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 16:44:51 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [kvm-unit-tests PATCH 12/17] x86/vmx: switch to new vmx.h secondary execution controls
Date: Tue, 16 Sep 2025 10:22:41 -0700
Message-ID: <20250916172247.610021-13-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250916172247.610021-1-jon@nutanix.com>
References: <20250916172247.610021-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF00013309.namprd07.prod.outlook.com
 (2603:10b6:518:1::18) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|DS0PR02MB9620:EE_
X-MS-Office365-Filtering-Correlation-Id: af212aa7-b39a-48fa-52e7-08ddf5405aed
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6Pe5q8BfmmurB9CcNTpUtK1KFT5u9T5K2/DnDY1QIHetN0Grx+HZ1FGwtLY8?=
 =?us-ascii?Q?+OEblHW28WH2+i++zZl5iYRLiznO+fowRS4Gazak/LMrYRmbAxdliGNaI6gt?=
 =?us-ascii?Q?Wk47lDWX0HV3XrQ28t/o2fjG9T1VDCKR38zU9jBeLaYDqtfR60QT6ROMwkfF?=
 =?us-ascii?Q?YyT2qIvxUCySh8kpeaO3K8cEaQb/DOtfJ1C3o8ivIInmHIqK6tcWG83ALAbW?=
 =?us-ascii?Q?nL+n/53chuH9kqJsEz9EGY1oOwNLx9YEouHIlveGE8YRxrSWNb8EbpZi9yC4?=
 =?us-ascii?Q?sJgYYFI0GaXw1Mcabe/XiNbBNaGzCrbLlEcvKnB1v+lbnUM8wBi48EVWsx4N?=
 =?us-ascii?Q?lAqJT+wrUzRKaU7f2XxvifuxoO8pXmPmLU5mvKxcxFIhUeqtK4TexQou0tVj?=
 =?us-ascii?Q?V9MHeFz4HRL5U7eIcrdjoSWAs5b27IW8mZHbe5CdlF1prcSTBXU97ilfpXcq?=
 =?us-ascii?Q?92+RRZca7ZtwIT52UIJWk4Vs2wWvgadaA+/SqYKFGsnXOWCPHJAhG7pDvBAv?=
 =?us-ascii?Q?NxMlC9Z33Dgj1qyrivfJaNBMM0BatEkZrBgWvkED+lr8uC4lq18APJqlAR8X?=
 =?us-ascii?Q?OhdSF3x2xvwCCJd7ioKNOZfvg9TPawbSax+kgYz46lC01Mj9t1O1ZfByvxUN?=
 =?us-ascii?Q?WoBX4mT2+R2Y8L7LrvIz1lHufCweqsWTHtWvzJjKW6kGR+qPykUqwWDkfqwt?=
 =?us-ascii?Q?Zj58g32L5/n9XfSlUw5p8TSNIOayn/6Bq2rpoxfrn8HTV8SbiesHcaMSMY5t?=
 =?us-ascii?Q?rPF5jz3oTMs+9gYffVZ93SHJNCB7ON4CpARzcGATTmuVHpPb2PwwYRaBascM?=
 =?us-ascii?Q?p4diplr5rB9F2BFGABH9nTPt7w59qNas2/C9DQdRsG1MM7VT65uerM/ngqtd?=
 =?us-ascii?Q?rBbqQG2FJYy/kwKmqNuLWJkpQKE8zop7uaCHPYHLuxBRagpnGq88pXit2PZJ?=
 =?us-ascii?Q?PmEN5qf9pcjp3B8/k36B9USg7evzpzyO7qMOBvQPzjcb75fmLuaZk+sPDs3j?=
 =?us-ascii?Q?35QQ47RBvir4wIzYb33D/aDckRQ4sXHz01CbsYK/+vYQfcL7BhLa+Qui5DbG?=
 =?us-ascii?Q?dcsVTN2imEAtElRTVVvPpAywaxXpyfWW3zLjTzHO/Yha/c7bo2TJa3mPTSPm?=
 =?us-ascii?Q?7rHcLwcwzfXoB3LE5jJiIilhGDxbyegDhPcI91LRere1gqEd4ZiEGOXsJKGl?=
 =?us-ascii?Q?MykDhLTm6G6IxsFKtHcPvvR7bngk8wHKCj6z+4K9+Ox/vGTmOpBz8SaG+rpz?=
 =?us-ascii?Q?WLcvMcLQzdH0QiRdMb9DOD36deB30UwGuscIUDb+in57/TX4Hg0pRDfA0qlh?=
 =?us-ascii?Q?KcroekVx50vu5rf0dP0+UYVlsYwi76IwxPrd6aJtxQsdpxQajIM3efimbv1E?=
 =?us-ascii?Q?aONTk6qOu184kxWHUnymH+JzLe7bJIxbBoUt2mahSc2D1jKrxtx42rVG7lf8?=
 =?us-ascii?Q?L4Dq1quAmHxNnvtzjO93/AAJsmtO1UAdMT4EQHSD1h/YHk3Nhu6FXA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TGJVXhGW6suf6NrE3wNvGUlX+9t/i/oWwIVAg9+QXUTwrI3QGW7AIukVvSc3?=
 =?us-ascii?Q?MSlpxEh2jRwzychf3wsXxAelsES9n0TZGghrSzFzV5Kc4MD9E62j84pq4xDU?=
 =?us-ascii?Q?aR751jE+8NcfKcnGXLyOKWAirb6YfuA12eFMMxGkisqd/54TPU7QcUyIWNHR?=
 =?us-ascii?Q?jbdyaIhqoJou0UKQoE/rUlAhu5qEmPDK++WhK7zdw+iBrN6fC63OhKJOtTSV?=
 =?us-ascii?Q?4OeCipDxYlatcIBoGQQoQvpWoH9OPCtD5JsakeT5cc9X/HFylDPrAEmO8Rww?=
 =?us-ascii?Q?peXsJecAjafwL2tJaM5rRtDkHfHZLOKIJsqYipIfFXRo5Y80D8hCZaMFOdXc?=
 =?us-ascii?Q?IgDok+LNYeUh5QKnwfQwSEMC/4wM/2BMlGiNKob4GjGPzOJR+F3aoJ+qOMra?=
 =?us-ascii?Q?YwQXsvG6Z6kPz6LM5qBXX8Xuis4sWP/vT7NUSUKj3kXvDzdMvG1ZG6J96EJP?=
 =?us-ascii?Q?lxXVpX7N3o1SoIhxv0eTR+RyaU3uEI0TK/Nk2lhCo5RsIjmEH+tvBdszSU+F?=
 =?us-ascii?Q?GqjplzW7Z0mueaE6h7CJvpQIckBaHiXmAZ58ituSxer8lue5xVcMppvI7PMh?=
 =?us-ascii?Q?5tzOAh7DQ1FPxDS9meX6yDW1Zl9NGopo0kr16tBL7um5TJXANpKQ8jfNWVK4?=
 =?us-ascii?Q?hD5P5v0C8nZgW6Vd5Q3fyc4MAlg2z4ntub4LeaSN73Oha/DjPchTgNaiGyq2?=
 =?us-ascii?Q?+ZtmUPmaC9IzDhyuqdWY8cppNm8f23op0x/sJlVd+e+Ya9iCSVaZVQVY2PHZ?=
 =?us-ascii?Q?fvF2zcjx27UsFOrbmzsg99yVWop8ZzdgiW7r8VycwdxDpaXu8XUu0uA2rs+E?=
 =?us-ascii?Q?jR0rnSU9SX3Mfx7N53fLyEF3et0JgoUOPQlj4UWHremMdejfaoSSQ9ySZOvO?=
 =?us-ascii?Q?oorc5aA1Fc2YcYatHOPGHCZEz/7iZXrzbuW3v5ZJDtsKcQQhGIHdUfE+fmDp?=
 =?us-ascii?Q?cWcOpQdnjpZjpzeOEvEB8aEPLFj4ty4+RwOATRfrW6ET1qV2LsfKnCxF4qoN?=
 =?us-ascii?Q?j2XDTi00Oq6PcFYh6SmgdQPbKc4h3wcJigx5PVk4LQ+0c8s3YHtD8DNyP+dj?=
 =?us-ascii?Q?d9K0NnefZLfTVEuk33FBsSsf96ptWigGfvEJoifvJ/XNoYBZf1i4NRDyma3T?=
 =?us-ascii?Q?WCyIiBso1jDTWbUXGuLKjXT+ymPVkdYoLfAxn6/N7aIEKFdxDZ36shEr0+Xl?=
 =?us-ascii?Q?OsCNNr8Xn3KoHeBHxJeExZmQBTV7a8mh7Gs4Ri6gebKQ8AWXTmHcAGBZlc7a?=
 =?us-ascii?Q?aubWrLhGvoRBcAtwmMGD2i7NCf8YJPhQ+hpxMWPCK8C4ZGklVrWSLa/nEKZ+?=
 =?us-ascii?Q?gWu4+AVrUBqtxw1/VvylV471s8QxFUQHe+WoJ6YLvPCHOTA8CtiPm+ZAJvdg?=
 =?us-ascii?Q?4XGVRUUHIG8uyJUSrl6185MKokGCZlm93HjzA1KRexz1M1aT6YgdxM9TQ96T?=
 =?us-ascii?Q?0rvy7SHKr5rmA/Ft+2R10friWVE53sfmlsBAARG3E89gRgnIb0qE8/StmFwj?=
 =?us-ascii?Q?RjRxr6yhle8Jtrlgzi/QxqrZdV4/fszMQIcOtXXVBXzfEZCtvi5vkWnZ1S9K?=
 =?us-ascii?Q?DmJM+6gUmOkp1axPaJKlr5zfxQ/RVW3fb5kUCw6RQyhssQTFYSZhLwpYD7Qx?=
 =?us-ascii?Q?Sw=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af212aa7-b39a-48fa-52e7-08ddf5405aed
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 16:44:51.1386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: liFsM/9vCjRkx/b8+G1SsqHqj0dmS7dj8HGkVX23ydgebg5TIYG178GwqwBjn0TE3J7h73wcJ7RfAibQbJV31gJ4eJFHmQQbfza8khESdJQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB9620
X-Authority-Analysis: v=2.4 cv=CYII5Krl c=1 sm=1 tr=0 ts=68c9940e cx=c_pps
 a=F+uFsNuNoBNH7XrxSTh6Og==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8
 a=JWULFVgWBiZiNmIsko8A:9
X-Proofpoint-ORIG-GUID: _FWn1ge2b8raeQGaUAX_ShbdtDPlteTJ
X-Proofpoint-GUID: _FWn1ge2b8raeQGaUAX_ShbdtDPlteTJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDE1NSBTYWx0ZWRfX36kRTGrDB2AC
 bfU686vgW3GB+DXDyL1GuO3H14LOBXFllr+qvIQbjRY6MRBib/5F6Ml55kUhwI62aVwx0ucyMGy
 pxMIfCEHgrQ6uEorQDzKzdlsm5lTc8uSe4xNx5R8zNX5CR8NgD2U6bbGKvfzCcQDHs6TZOAeI6K
 x1PJGU5FlLCiFm5YvEb1bpiGDBCQ2DNfjBXFLtITy0W6y/1vdio0t1h3smHVHmFFAq8Pl+AQzkS
 cBI2tbyNUGH0IUiAaP5rp9J0HzDZSakFaJKX9TpWRC3mhhwOxLYgUsGrLb51xAPaE1LMgMNj7Ac
 8bjHkbs0RUg89SfQtt3yo0M2PCU4rlZ6aAZNM+74x7M47Ky+g4Qu9tUfzKTCYs=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

Migrate to new vmx.h's secondary execution controls, which makes it
easier to grok from one code base to another.

No functional change intended.

Signed-off-by: Jon Kohler <jon@nutanix.com>

---
 x86/vmx.c       |   6 +-
 x86/vmx.h       |  20 +----
 x86/vmx_tests.c | 220 ++++++++++++++++++++++++++++--------------------
 3 files changed, 136 insertions(+), 110 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index f3368a4a..dc52efa7 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1300,7 +1300,8 @@ static void init_vmx_caps(void)
 		ctrl_cpu_rev[1].val = rdmsr(MSR_IA32_VMX_PROCBASED_CTLS2);
 	else
 		ctrl_cpu_rev[1].val = 0;
-	if ((ctrl_cpu_rev[1].clr & (CPU_EPT | CPU_VPID)) != 0)
+	if ((ctrl_cpu_rev[1].clr &
+		 (SECONDARY_EXEC_ENABLE_EPT | SECONDARY_EXEC_ENABLE_VPID)) != 0)
 		ept_vpid.val = rdmsr(MSR_IA32_VMX_EPT_VPID_CAP);
 	else
 		ept_vpid.val = 0;
@@ -1607,7 +1608,8 @@ static void test_vmx_caps(void)
 	       "MSR_IA32_VMX_BASIC");
 
 	val = rdmsr(MSR_IA32_VMX_MISC);
-	report((!(ctrl_cpu_rev[1].clr & CPU_URG) || val & (1ul << 5)) &&
+	report((!(ctrl_cpu_rev[1].clr &
+			  SECONDARY_EXEC_UNRESTRICTED_GUEST) || val & (1ul << 5)) &&
 	       ((val >> 16) & 0x1ff) <= 256 &&
 	       (val & 0x80007e00) == 0,
 	       "MSR_IA32_VMX_MISC");
diff --git a/x86/vmx.h b/x86/vmx.h
index 16332247..36e784a7 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -435,24 +435,6 @@ enum Ctrl_pin {
 	PIN_POST_INTR		= 1ul << 7,
 };
 
-enum Ctrl1 {
-	CPU_VIRT_APIC_ACCESSES	= 1ul << 0,
-	CPU_EPT			= 1ul << 1,
-	CPU_DESC_TABLE		= 1ul << 2,
-	CPU_RDTSCP		= 1ul << 3,
-	CPU_VIRT_X2APIC		= 1ul << 4,
-	CPU_VPID		= 1ul << 5,
-	CPU_WBINVD		= 1ul << 6,
-	CPU_URG			= 1ul << 7,
-	CPU_APIC_REG_VIRT	= 1ul << 8,
-	CPU_VINTD		= 1ul << 9,
-	CPU_RDRAND		= 1ul << 11,
-	CPU_SHADOW_VMCS		= 1ul << 14,
-	CPU_RDSEED		= 1ul << 16,
-	CPU_PML                 = 1ul << 17,
-	CPU_USE_TSC_SCALING	= 1ul << 25,
-};
-
 enum Intr_type {
 	VMX_INTR_TYPE_EXT_INTR = 0,
 	VMX_INTR_TYPE_NMI_INTR = 2,
@@ -686,7 +668,7 @@ static inline bool is_invept_type_supported(u64 type)
 static inline bool is_vpid_supported(void)
 {
 	return (ctrl_cpu_rev[0].clr & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) &&
-	       (ctrl_cpu_rev[1].clr & CPU_VPID);
+	       (ctrl_cpu_rev[1].clr & SECONDARY_EXEC_ENABLE_VPID);
 }
 
 static inline bool is_invvpid_supported(void)
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index f092c22d..ba50f2ee 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -909,17 +909,27 @@ static struct insn_table insn_table[] = {
 		0, 0, 0, this_cpu_has_mwait},
 	{"PAUSE", CPU_BASED_PAUSE_EXITING, insn_pause, INSN_CPU0, 40, 0, 0, 0},
 	// Flags for Secondary Processor-Based VM-Execution Controls
-	{"WBINVD", CPU_WBINVD, insn_wbinvd, INSN_CPU1, 54, 0, 0, 0},
-	{"DESC_TABLE (SGDT)", CPU_DESC_TABLE, insn_sgdt, INSN_CPU1, 46, 0, 0, 0},
-	{"DESC_TABLE (LGDT)", CPU_DESC_TABLE, insn_lgdt, INSN_CPU1, 46, 0, 0, 0},
-	{"DESC_TABLE (SIDT)", CPU_DESC_TABLE, insn_sidt, INSN_CPU1, 46, 0, 0, 0},
-	{"DESC_TABLE (LIDT)", CPU_DESC_TABLE, insn_lidt, INSN_CPU1, 46, 0, 0, 0},
-	{"DESC_TABLE (SLDT)", CPU_DESC_TABLE, insn_sldt, INSN_CPU1, 47, 0, 0, 0},
-	{"DESC_TABLE (LLDT)", CPU_DESC_TABLE, insn_lldt, INSN_CPU1, 47, 0, 0, 0},
-	{"DESC_TABLE (STR)", CPU_DESC_TABLE, insn_str, INSN_CPU1, 47, 0, 0, 0},
+	{"WBINVD", SECONDARY_EXEC_WBINVD_EXITING, insn_wbinvd, INSN_CPU1, 54,
+		0, 0, 0},
+	{"DESC_TABLE (SGDT)", SECONDARY_EXEC_DESC, insn_sgdt, INSN_CPU1, 46,
+		0, 0, 0},
+	{"DESC_TABLE (LGDT)", SECONDARY_EXEC_DESC, insn_lgdt, INSN_CPU1, 46,
+		0, 0, 0},
+	{"DESC_TABLE (SIDT)", SECONDARY_EXEC_DESC, insn_sidt, INSN_CPU1, 46,
+		0, 0, 0},
+	{"DESC_TABLE (LIDT)", SECONDARY_EXEC_DESC, insn_lidt, INSN_CPU1, 46,
+		0, 0, 0},
+	{"DESC_TABLE (SLDT)", SECONDARY_EXEC_DESC, insn_sldt, INSN_CPU1, 47,
+		0, 0, 0},
+	{"DESC_TABLE (LLDT)", SECONDARY_EXEC_DESC, insn_lldt, INSN_CPU1, 47,
+		0, 0, 0},
+	{"DESC_TABLE (STR)", SECONDARY_EXEC_DESC, insn_str, INSN_CPU1, 47,
+		0, 0, 0},
 	/* LTR causes a #GP if done with a busy selector, so it is not tested.  */
-	{"RDRAND", CPU_RDRAND, insn_rdrand, INSN_CPU1, VMX_RDRAND, 0, 0, 0},
-	{"RDSEED", CPU_RDSEED, insn_rdseed, INSN_CPU1, VMX_RDSEED, 0, 0, 0},
+	{"RDRAND", SECONDARY_EXEC_RDRAND_EXITING, insn_rdrand, INSN_CPU1,
+		VMX_RDRAND, 0, 0, 0},
+	{"RDSEED", SECONDARY_EXEC_RDSEED_EXITING, insn_rdseed, INSN_CPU1,
+		VMX_RDSEED, 0, 0, 0},
 	// Instructions always trap
 	{"CPUID", 0, insn_cpuid, INSN_ALWAYS_TRAP, 10, 0, 0, 0},
 	{"INVD", 0, insn_invd, INSN_ALWAYS_TRAP, 13, 0, 0, 0},
@@ -1052,7 +1062,7 @@ static int insn_intercept_exit_handler(union exit_reason exit_reason)
 static int __setup_ept(u64 hpa, bool enable_ad)
 {
 	if (!(ctrl_cpu_rev[0].clr & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) ||
-	    !(ctrl_cpu_rev[1].clr & CPU_EPT)) {
+	    !(ctrl_cpu_rev[1].clr & SECONDARY_EXEC_ENABLE_EPT)) {
 		printf("\tEPT is not supported\n");
 		return 1;
 	}
@@ -1077,7 +1087,8 @@ static int __setup_ept(u64 hpa, bool enable_ad)
 	vmcs_write(EPTP, eptp);
 	vmcs_write(CPU_EXEC_CTRL0, vmcs_read(CPU_EXEC_CTRL0) |
 		   CPU_BASED_ACTIVATE_SECONDARY_CONTROLS);
-	vmcs_write(CPU_EXEC_CTRL1, vmcs_read(CPU_EXEC_CTRL1)| CPU_EPT);
+	vmcs_write(CPU_EXEC_CTRL1, vmcs_read(CPU_EXEC_CTRL1) |
+		   SECONDARY_EXEC_ENABLE_EPT);
 
 	return 0;
 }
@@ -1131,8 +1142,8 @@ static void setup_dummy_ept(void)
 static int enable_unrestricted_guest(bool need_valid_ept)
 {
 	if (!(ctrl_cpu_rev[0].clr & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) ||
-	    !(ctrl_cpu_rev[1].clr & CPU_URG) ||
-	    !(ctrl_cpu_rev[1].clr & CPU_EPT))
+	    !(ctrl_cpu_rev[1].clr & SECONDARY_EXEC_UNRESTRICTED_GUEST) ||
+	    !(ctrl_cpu_rev[1].clr & SECONDARY_EXEC_ENABLE_EPT))
 		return 1;
 
 	if (need_valid_ept)
@@ -1142,7 +1153,8 @@ static int enable_unrestricted_guest(bool need_valid_ept)
 
 	vmcs_write(CPU_EXEC_CTRL0, vmcs_read(CPU_EXEC_CTRL0) |
 		   CPU_BASED_ACTIVATE_SECONDARY_CONTROLS);
-	vmcs_write(CPU_EXEC_CTRL1, vmcs_read(CPU_EXEC_CTRL1) | CPU_URG);
+	vmcs_write(CPU_EXEC_CTRL1, vmcs_read(CPU_EXEC_CTRL1) |
+		   SECONDARY_EXEC_UNRESTRICTED_GUEST);
 
 	return 0;
 }
@@ -1550,7 +1562,7 @@ static int pml_init(struct vmcs *vmcs)
 		return r;
 
 	if (!(ctrl_cpu_rev[0].clr & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) ||
-		!(ctrl_cpu_rev[1].clr & CPU_PML)) {
+		!(ctrl_cpu_rev[1].clr & SECONDARY_EXEC_ENABLE_PML)) {
 		printf("\tPML is not supported");
 		return VMX_TEST_EXIT;
 	}
@@ -1559,7 +1571,7 @@ static int pml_init(struct vmcs *vmcs)
 	vmcs_write(PMLADDR, (u64)pml_log);
 	vmcs_write(GUEST_PML_INDEX, PML_INDEX - 1);
 
-	ctrl_cpu = vmcs_read(CPU_EXEC_CTRL1) | CPU_PML;
+	ctrl_cpu = vmcs_read(CPU_EXEC_CTRL1) | SECONDARY_EXEC_ENABLE_PML;
 	vmcs_write(CPU_EXEC_CTRL1, ctrl_cpu);
 
 	return VMX_TEST_START;
@@ -2104,7 +2116,7 @@ static int disable_rdtscp_init(struct vmcs *vmcs)
 
 	if (ctrl_cpu_rev[0].clr & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) {
 		ctrl_cpu1 = vmcs_read(CPU_EXEC_CTRL1);
-		ctrl_cpu1 &= ~CPU_RDTSCP;
+		ctrl_cpu1 &= ~SECONDARY_EXEC_ENABLE_RDTSCP;
 		vmcs_write(CPU_EXEC_CTRL1, ctrl_cpu1);
 	}
 
@@ -3885,7 +3897,8 @@ static void test_apic_access_addr(void)
 
 	vmcs_write(APIC_ACCS_ADDR, virt_to_phys(apic_access_page));
 
-	test_vmcs_addr_reference(CPU_VIRT_APIC_ACCESSES, APIC_ACCS_ADDR,
+	test_vmcs_addr_reference(SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES,
+				 APIC_ACCS_ADDR,
 				 "APIC-access address",
 				 "virtualize APIC-accesses", PAGE_SIZE,
 				 true, false);
@@ -3896,9 +3909,9 @@ static bool set_bit_pattern(u8 mask, u32 *secondary)
 	u8 i;
 	bool flag = false;
 	u32 test_bits[3] = {
-		CPU_VIRT_X2APIC,
-		CPU_APIC_REG_VIRT,
-		CPU_VINTD
+		SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE,
+		SECONDARY_EXEC_APIC_REGISTER_VIRT,
+		SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY
 	};
 
         for (i = 0; i < ARRAY_SIZE(test_bits); i++) {
@@ -3948,7 +3961,9 @@ static void test_apic_virtual_ctls(void)
 
 	while (1) {
 		for (j = 1; j < 8; j++) {
-			secondary &= ~(CPU_VIRT_X2APIC | CPU_APIC_REG_VIRT | CPU_VINTD);
+			secondary &= ~(SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |
+				       SECONDARY_EXEC_APIC_REGISTER_VIRT |
+				       SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
 			if (primary & CPU_BASED_TPR_SHADOW) {
 				is_ctrl_valid = true;
 			} else {
@@ -3959,8 +3974,12 @@ static void test_apic_virtual_ctls(void)
 			}
 
 			vmcs_write(CPU_EXEC_CTRL1, secondary);
-			report_prefix_pushf("Use TPR shadow %s, virtualize x2APIC mode %s, APIC-register virtualization %s, virtual-interrupt delivery %s",
-				str, (secondary & CPU_VIRT_X2APIC) ? "enabled" : "disabled", (secondary & CPU_APIC_REG_VIRT) ? "enabled" : "disabled", (secondary & CPU_VINTD) ? "enabled" : "disabled");
+			report_prefix_pushf(
+				"Use TPR shadow %s, virtualize x2APIC mode %s, APIC-register virtualization %s, virtual-interrupt delivery %s",
+				str,
+				(secondary & SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE) ? "enabled" : "disabled",
+				(secondary & SECONDARY_EXEC_APIC_REGISTER_VIRT) ? "enabled" : "disabled",
+				(secondary & SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY) ? "enabled" : "disabled");
 			if (is_ctrl_valid)
 				test_vmx_valid_controls();
 			else
@@ -3980,7 +3999,8 @@ static void test_apic_virtual_ctls(void)
 	/*
 	 * Second test
 	 */
-	u32 apic_virt_ctls = (CPU_VIRT_X2APIC | CPU_VIRT_APIC_ACCESSES);
+	u32 apic_virt_ctls = (SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |
+			      SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES);
 
 	primary = saved_primary;
 	secondary = saved_secondary;
@@ -3989,23 +4009,27 @@ static void test_apic_virtual_ctls(void)
 
 	vmcs_write(CPU_EXEC_CTRL0,
 		   primary | CPU_BASED_ACTIVATE_SECONDARY_CONTROLS);
-	secondary &= ~CPU_VIRT_APIC_ACCESSES;
-	vmcs_write(CPU_EXEC_CTRL1, secondary & ~CPU_VIRT_X2APIC);
+	secondary &= ~SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
+	vmcs_write(CPU_EXEC_CTRL1,
+		   secondary & ~SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE);
 	report_prefix_pushf("Virtualize x2APIC mode disabled; virtualize APIC access disabled");
 	test_vmx_valid_controls();
 	report_prefix_pop();
 
-	vmcs_write(CPU_EXEC_CTRL1, secondary | CPU_VIRT_APIC_ACCESSES);
+	vmcs_write(CPU_EXEC_CTRL1,
+		   secondary | SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES);
 	report_prefix_pushf("Virtualize x2APIC mode disabled; virtualize APIC access enabled");
 	test_vmx_valid_controls();
 	report_prefix_pop();
 
-	vmcs_write(CPU_EXEC_CTRL1, secondary | CPU_VIRT_X2APIC);
+	vmcs_write(CPU_EXEC_CTRL1,
+		   secondary | SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE);
 	report_prefix_pushf("Virtualize x2APIC mode enabled; virtualize APIC access enabled");
 	test_vmx_invalid_controls();
 	report_prefix_pop();
 
-	vmcs_write(CPU_EXEC_CTRL1, secondary & ~CPU_VIRT_APIC_ACCESSES);
+	vmcs_write(CPU_EXEC_CTRL1,
+		   secondary & ~SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES);
 	report_prefix_pushf("Virtualize x2APIC mode enabled; virtualize APIC access disabled");
 	test_vmx_valid_controls();
 	report_prefix_pop();
@@ -4028,20 +4052,22 @@ static void test_virtual_intr_ctls(void)
 	u32 secondary = saved_secondary;
 	u32 pin = saved_pin;
 
-	if (!((ctrl_cpu_rev[1].clr & CPU_VINTD) &&
+	if (!((ctrl_cpu_rev[1].clr & SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY) &&
 	    (ctrl_pin_rev.clr & PIN_EXTINT)))
 		return;
 
 	vmcs_write(CPU_EXEC_CTRL0,
 		   primary | CPU_BASED_ACTIVATE_SECONDARY_CONTROLS |
 		   CPU_BASED_TPR_SHADOW);
-	vmcs_write(CPU_EXEC_CTRL1, secondary & ~CPU_VINTD);
+	vmcs_write(CPU_EXEC_CTRL1,
+		   secondary & ~SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
 	vmcs_write(PIN_CONTROLS, pin & ~PIN_EXTINT);
 	report_prefix_pushf("Virtualize interrupt-delivery disabled; external-interrupt exiting disabled");
 	test_vmx_valid_controls();
 	report_prefix_pop();
 
-	vmcs_write(CPU_EXEC_CTRL1, secondary | CPU_VINTD);
+	vmcs_write(CPU_EXEC_CTRL1,
+		   secondary | SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
 	report_prefix_pushf("Virtualize interrupt-delivery enabled; external-interrupt exiting disabled");
 	test_vmx_invalid_controls();
 	report_prefix_pop();
@@ -4099,7 +4125,7 @@ static void test_posted_intr(void)
 	int i;
 
 	if (!((ctrl_pin_rev.clr & PIN_POST_INTR) &&
-	    (ctrl_cpu_rev[1].clr & CPU_VINTD) &&
+	    (ctrl_cpu_rev[1].clr & SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY) &&
 	    (ctrl_exit_rev.clr & EXI_INTA)))
 		return;
 
@@ -4112,13 +4138,13 @@ static void test_posted_intr(void)
 	 */
 	pin |= PIN_POST_INTR;
 	vmcs_write(PIN_CONTROLS, pin);
-	secondary &= ~CPU_VINTD;
+	secondary &= ~SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY;
 	vmcs_write(CPU_EXEC_CTRL1, secondary);
 	report_prefix_pushf("Process-posted-interrupts enabled; virtual-interrupt-delivery disabled");
 	test_vmx_invalid_controls();
 	report_prefix_pop();
 
-	secondary |= CPU_VINTD;
+	secondary |= SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY;
 	vmcs_write(CPU_EXEC_CTRL1, secondary);
 	report_prefix_pushf("Process-posted-interrupts enabled; virtual-interrupt-delivery enabled");
 	test_vmx_invalid_controls();
@@ -4136,13 +4162,13 @@ static void test_posted_intr(void)
 	test_vmx_valid_controls();
 	report_prefix_pop();
 
-	secondary &= ~CPU_VINTD;
+	secondary &= ~SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY;
 	vmcs_write(CPU_EXEC_CTRL1, secondary);
 	report_prefix_pushf("Process-posted-interrupts enabled; virtual-interrupt-delivery disabled; acknowledge-interrupt-on-exit enabled");
 	test_vmx_invalid_controls();
 	report_prefix_pop();
 
-	secondary |= CPU_VINTD;
+	secondary |= SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY;
 	vmcs_write(CPU_EXEC_CTRL1, secondary);
 	report_prefix_pushf("Process-posted-interrupts enabled; virtual-interrupt-delivery enabled; acknowledge-interrupt-on-exit enabled");
 	test_vmx_valid_controls();
@@ -4223,13 +4249,15 @@ static void test_vpid(void)
 
 	vmcs_write(CPU_EXEC_CTRL0,
 		   saved_primary | CPU_BASED_ACTIVATE_SECONDARY_CONTROLS);
-	vmcs_write(CPU_EXEC_CTRL1, saved_secondary & ~CPU_VPID);
+	vmcs_write(CPU_EXEC_CTRL1,
+		   saved_secondary & ~SECONDARY_EXEC_ENABLE_VPID);
 	vmcs_write(VPID, vpid);
 	report_prefix_pushf("VPID disabled; VPID value %x", vpid);
 	test_vmx_valid_controls();
 	report_prefix_pop();
 
-	vmcs_write(CPU_EXEC_CTRL1, saved_secondary | CPU_VPID);
+	vmcs_write(CPU_EXEC_CTRL1,
+		   saved_secondary | SECONDARY_EXEC_ENABLE_VPID);
 	report_prefix_pushf("VPID enabled; VPID value %x", vpid);
 	test_vmx_invalid_controls();
 	report_prefix_pop();
@@ -4259,7 +4287,8 @@ static void try_tpr_threshold_and_vtpr(unsigned threshold, unsigned vtpr)
 
 	if ((primary & CPU_BASED_TPR_SHADOW) &&
 	    (!(primary & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) ||
-	     !(secondary & (CPU_VINTD | CPU_VIRT_APIC_ACCESSES))))
+	     !(secondary & (SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
+			    SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES))))
 		valid = (threshold & 0xf) <= ((vtpr >> 4) & 0xf);
 
 	set_vtpr(vtpr);
@@ -4352,7 +4381,7 @@ static void test_invalid_event_injection(void)
 
 	/* Assert that unrestricted guest is disabled or unsupported */
 	assert(!(ctrl_cpu_rev[0].clr & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) ||
-	       !(secondary_save & CPU_URG));
+	       !(secondary_save & SECONDARY_EXEC_UNRESTRICTED_GUEST));
 
 	ent_intr_info = ent_intr_info_base | INTR_TYPE_HARD_EXCEPTION |
 			GP_VECTOR;
@@ -4593,7 +4622,7 @@ static void try_tpr_threshold(unsigned threshold)
 
 	if ((primary & CPU_BASED_TPR_SHADOW) &&
 	    !((primary & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) &&
-	    (secondary & CPU_VINTD)))
+	    (secondary & SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY)))
 		valid = !(threshold >> 4);
 
 	set_vtpr(-1);
@@ -4667,12 +4696,14 @@ static void test_tpr_threshold(void)
 	report_prefix_pop();
 
 	if (!((ctrl_cpu_rev[0].clr & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) &&
-	    (ctrl_cpu_rev[1].clr & (CPU_VINTD  | CPU_VIRT_APIC_ACCESSES))))
+	    (ctrl_cpu_rev[1].clr & (SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
+				    SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES))))
 		goto out;
 	u32 secondary = vmcs_read(CPU_EXEC_CTRL1);
 
-	if (ctrl_cpu_rev[1].clr & CPU_VINTD) {
-		vmcs_write(CPU_EXEC_CTRL1, CPU_VINTD);
+	if (ctrl_cpu_rev[1].clr & SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY) {
+		vmcs_write(CPU_EXEC_CTRL1,
+			   SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
 		report_prefix_pushf("Use TPR shadow enabled; secondary controls disabled; virtual-interrupt delivery enabled; virtualize APIC accesses disabled");
 		test_tpr_threshold_values();
 		report_prefix_pop();
@@ -4685,11 +4716,12 @@ static void test_tpr_threshold(void)
 		report_prefix_pop();
 	}
 
-	if (ctrl_cpu_rev[1].clr & CPU_VIRT_APIC_ACCESSES) {
+	if (ctrl_cpu_rev[1].clr & SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES) {
 		vmcs_write(CPU_EXEC_CTRL0,
 			   vmcs_read(CPU_EXEC_CTRL0) &
 			   ~CPU_BASED_ACTIVATE_SECONDARY_CONTROLS);
-		vmcs_write(CPU_EXEC_CTRL1, CPU_VIRT_APIC_ACCESSES);
+		vmcs_write(CPU_EXEC_CTRL1,
+			   SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES);
 		report_prefix_pushf("Use TPR shadow enabled; secondary controls disabled; virtual-interrupt delivery enabled; virtualize APIC accesses enabled");
 		test_tpr_threshold_values();
 		report_prefix_pop();
@@ -4703,13 +4735,14 @@ static void test_tpr_threshold(void)
 	}
 
 	if ((ctrl_cpu_rev[1].clr &
-	     (CPU_VINTD | CPU_VIRT_APIC_ACCESSES)) ==
-	    (CPU_VINTD | CPU_VIRT_APIC_ACCESSES)) {
+	     (SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY | SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)) ==
+	    (SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY | SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)) {
 		vmcs_write(CPU_EXEC_CTRL0,
 			   vmcs_read(CPU_EXEC_CTRL0) &
 			   ~CPU_BASED_ACTIVATE_SECONDARY_CONTROLS);
 		vmcs_write(CPU_EXEC_CTRL1,
-			   CPU_VINTD | CPU_VIRT_APIC_ACCESSES);
+			   SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
+			   SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES);
 		report_prefix_pushf("Use TPR shadow enabled; secondary controls disabled; virtual-interrupt delivery enabled; virtualize APIC accesses enabled");
 		test_tpr_threshold_values();
 		report_prefix_pop();
@@ -4961,29 +4994,30 @@ static void test_ept_eptp(void)
 		report_prefix_pop();
 	}
 
-	secondary &= ~(CPU_EPT | CPU_URG);
+	secondary &= ~(SECONDARY_EXEC_ENABLE_EPT |
+		       SECONDARY_EXEC_UNRESTRICTED_GUEST);
 	vmcs_write(CPU_EXEC_CTRL1, secondary);
 	report_prefix_pushf("Enable-EPT disabled, unrestricted-guest disabled");
 	test_vmx_valid_controls();
 	report_prefix_pop();
 
-	if (!(ctrl_cpu_rev[1].clr & CPU_URG))
+	if (!(ctrl_cpu_rev[1].clr & SECONDARY_EXEC_UNRESTRICTED_GUEST))
 		goto skip_unrestricted_guest;
 
-	secondary |= CPU_URG;
+	secondary |= SECONDARY_EXEC_UNRESTRICTED_GUEST;
 	vmcs_write(CPU_EXEC_CTRL1, secondary);
 	report_prefix_pushf("Enable-EPT disabled, unrestricted-guest enabled");
 	test_vmx_invalid_controls();
 	report_prefix_pop();
 
-	secondary |= CPU_EPT;
+	secondary |= SECONDARY_EXEC_ENABLE_EPT;
 	setup_dummy_ept();
 	report_prefix_pushf("Enable-EPT enabled, unrestricted-guest enabled");
 	test_vmx_valid_controls();
 	report_prefix_pop();
 
 skip_unrestricted_guest:
-	secondary &= ~CPU_URG;
+	secondary &= ~SECONDARY_EXEC_UNRESTRICTED_GUEST;
 	vmcs_write(CPU_EXEC_CTRL1, secondary);
 	report_prefix_pushf("Enable-EPT enabled, unrestricted-guest disabled");
 	test_vmx_valid_controls();
@@ -5013,38 +5047,40 @@ static void test_pml(void)
 	u32 secondary = secondary_saved;
 
 	if (!((ctrl_cpu_rev[0].clr & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) &&
-	    (ctrl_cpu_rev[1].clr & CPU_EPT) && (ctrl_cpu_rev[1].clr & CPU_PML))) {
+	      (ctrl_cpu_rev[1].clr & SECONDARY_EXEC_ENABLE_EPT) &&
+	      (ctrl_cpu_rev[1].clr & SECONDARY_EXEC_ENABLE_PML))) {
 		report_skip("%s : \"Secondary execution\" or \"enable EPT\" or \"enable PML\" control not supported", __func__);
 		return;
 	}
 
 	primary |= CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
 	vmcs_write(CPU_EXEC_CTRL0, primary);
-	secondary &= ~(CPU_PML | CPU_EPT);
+	secondary &= ~(SECONDARY_EXEC_ENABLE_PML | SECONDARY_EXEC_ENABLE_EPT);
 	vmcs_write(CPU_EXEC_CTRL1, secondary);
 	report_prefix_pushf("enable-PML disabled, enable-EPT disabled");
 	test_vmx_valid_controls();
 	report_prefix_pop();
 
-	secondary |= CPU_PML;
+	secondary |= SECONDARY_EXEC_ENABLE_PML;
 	vmcs_write(CPU_EXEC_CTRL1, secondary);
 	report_prefix_pushf("enable-PML enabled, enable-EPT disabled");
 	test_vmx_invalid_controls();
 	report_prefix_pop();
 
-	secondary |= CPU_EPT;
+	secondary |= SECONDARY_EXEC_ENABLE_EPT;
 	setup_dummy_ept();
 	report_prefix_pushf("enable-PML enabled, enable-EPT enabled");
 	test_vmx_valid_controls();
 	report_prefix_pop();
 
-	secondary &= ~CPU_PML;
+	secondary &= ~SECONDARY_EXEC_ENABLE_PML;
 	vmcs_write(CPU_EXEC_CTRL1, secondary);
 	report_prefix_pushf("enable-PML disabled, enable EPT enabled");
 	test_vmx_valid_controls();
 	report_prefix_pop();
 
-	test_vmcs_addr_reference(CPU_PML, PMLADDR, "PML address", "PML",
+	test_vmcs_addr_reference(SECONDARY_EXEC_ENABLE_PML,
+				 PMLADDR, "PML address", "PML",
 				 PAGE_SIZE, false, false);
 
 	vmcs_write(CPU_EXEC_CTRL0, primary_saved);
@@ -5297,13 +5333,14 @@ static void vmx_mtf_pdpte_test(void)
 		return;
 	}
 
-	if (!(ctrl_cpu_rev[1].clr & CPU_URG)) {
+	if (!(ctrl_cpu_rev[1].clr & SECONDARY_EXEC_UNRESTRICTED_GUEST)) {
 		report_skip("%s : \"Unrestricted guest\" exec control not supported", __func__);
 		return;
 	}
 
 	vmcs_write(EXC_BITMAP, ~0);
-	vmcs_write(CPU_EXEC_CTRL1, vmcs_read(CPU_EXEC_CTRL1) | CPU_URG);
+	vmcs_write(CPU_EXEC_CTRL1, vmcs_read(CPU_EXEC_CTRL1) |
+		   SECONDARY_EXEC_UNRESTRICTED_GUEST);
 
 	/*
 	 * Copy the guest code to an identity-mapped page.
@@ -6205,13 +6242,13 @@ static enum Config_type configure_apic_reg_virt_test(
 	}
 
 	if (apic_reg_virt_config->virtualize_apic_accesses) {
-		if (!(ctrl_cpu_rev[1].clr & CPU_VIRT_APIC_ACCESSES)) {
+		if (!(ctrl_cpu_rev[1].clr & SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)) {
 			printf("VM-execution control \"virtualize APIC accesses\" NOT supported.\n");
 			return CONFIG_TYPE_UNSUPPORTED;
 		}
-		cpu_exec_ctrl1 |= CPU_VIRT_APIC_ACCESSES;
+		cpu_exec_ctrl1 |= SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
 	} else {
-		cpu_exec_ctrl1 &= ~CPU_VIRT_APIC_ACCESSES;
+		cpu_exec_ctrl1 &= ~SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
 	}
 
 	if (apic_reg_virt_config->use_tpr_shadow) {
@@ -6225,23 +6262,23 @@ static enum Config_type configure_apic_reg_virt_test(
 	}
 
 	if (apic_reg_virt_config->apic_register_virtualization) {
-		if (!(ctrl_cpu_rev[1].clr & CPU_APIC_REG_VIRT)) {
+		if (!(ctrl_cpu_rev[1].clr & SECONDARY_EXEC_APIC_REGISTER_VIRT)) {
 			printf("VM-execution control \"APIC-register virtualization\" NOT supported.\n");
 			return CONFIG_TYPE_UNSUPPORTED;
 		}
-		cpu_exec_ctrl1 |= CPU_APIC_REG_VIRT;
+		cpu_exec_ctrl1 |= SECONDARY_EXEC_APIC_REGISTER_VIRT;
 	} else {
-		cpu_exec_ctrl1 &= ~CPU_APIC_REG_VIRT;
+		cpu_exec_ctrl1 &= ~SECONDARY_EXEC_APIC_REGISTER_VIRT;
 	}
 
 	if (apic_reg_virt_config->virtualize_x2apic_mode) {
-		if (!(ctrl_cpu_rev[1].clr & CPU_VIRT_X2APIC)) {
+		if (!(ctrl_cpu_rev[1].clr & SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE)) {
 			printf("VM-execution control \"virtualize x2APIC mode\" NOT supported.\n");
 			return CONFIG_TYPE_UNSUPPORTED;
 		}
-		cpu_exec_ctrl1 |= CPU_VIRT_X2APIC;
+		cpu_exec_ctrl1 |= SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE;
 	} else {
-		cpu_exec_ctrl1 &= ~CPU_VIRT_X2APIC;
+		cpu_exec_ctrl1 &= ~SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE;
 	}
 
 	vmcs_write(CPU_EXEC_CTRL0, cpu_exec_ctrl0);
@@ -6255,8 +6292,8 @@ static enum Config_type configure_apic_reg_virt_test(
 
 static bool cpu_has_apicv(void)
 {
-	return ((ctrl_cpu_rev[1].clr & CPU_APIC_REG_VIRT) &&
-		(ctrl_cpu_rev[1].clr & CPU_VINTD) &&
+	return ((ctrl_cpu_rev[1].clr & SECONDARY_EXEC_APIC_REGISTER_VIRT) &&
+		(ctrl_cpu_rev[1].clr & SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY) &&
 		(ctrl_pin_rev.clr & PIN_POST_INTR));
 }
 
@@ -6277,7 +6314,7 @@ static void apic_reg_virt_test(void)
 	}
 
 	control = cpu_exec_ctrl1;
-	control &= ~CPU_VINTD;
+	control &= ~SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY;
 	vmcs_write(CPU_EXEC_CTRL1, control);
 
 	test_set_guest(apic_reg_virt_guest);
@@ -7004,13 +7041,13 @@ static enum Config_type configure_virt_x2apic_mode_test(
 	}
 
 	if (virt_x2apic_mode_config->virtual_interrupt_delivery) {
-		if (!(ctrl_cpu_rev[1].clr & CPU_VINTD)) {
+		if (!(ctrl_cpu_rev[1].clr & SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY)) {
 			report_skip("%s : \"virtual-interrupt delivery\" exec control not supported", __func__);
 			return CONFIG_TYPE_UNSUPPORTED;
 		}
-		cpu_exec_ctrl1 |= CPU_VINTD;
+		cpu_exec_ctrl1 |= SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY;
 	} else {
-		cpu_exec_ctrl1 &= ~CPU_VINTD;
+		cpu_exec_ctrl1 &= ~SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY;
 	}
 
 	vmcs_write(CPU_EXEC_CTRL0, cpu_exec_ctrl0);
@@ -8089,7 +8126,7 @@ static void test_guest_segment_sel_fields(void)
 	cpu_ctrl1_saved = vmcs_read(CPU_EXEC_CTRL1);
 	ar_saved = vmcs_read(GUEST_AR_SS);
 	/* Turn off "unrestricted guest" vm-execution control */
-	vmcs_write(CPU_EXEC_CTRL1, cpu_ctrl1_saved & ~CPU_URG);
+	vmcs_write(CPU_EXEC_CTRL1, cpu_ctrl1_saved & ~SECONDARY_EXEC_UNRESTRICTED_GUEST);
 	cs_rpl_bits = vmcs_read(GUEST_SEL_CS) & 0x3;
 	sel_saved = vmcs_read(GUEST_SEL_SS);
 	TEST_INVALID_SEG_SEL(GUEST_SEL_SS, ((sel_saved & ~0x3) | (~cs_rpl_bits & 0x3)));
@@ -8302,13 +8339,17 @@ static void vmentry_unrestricted_guest_test(void)
 
 	test_set_guest(unrestricted_guest_main);
 	setup_unrestricted_guest();
-	test_guest_state("Unrestricted guest test", false, CPU_URG, "CPU_URG");
+	test_guest_state("Unrestricted guest test", false,
+			 SECONDARY_EXEC_UNRESTRICTED_GUEST,
+			 "SECONDARY_EXEC_UNRESTRICTED_GUEST");
 
 	/*
 	 * Let the guest finish execution as a regular guest
 	 */
 	unsetup_unrestricted_guest();
-	vmcs_write(CPU_EXEC_CTRL1, vmcs_read(CPU_EXEC_CTRL1) & ~CPU_URG);
+	vmcs_write(CPU_EXEC_CTRL1,
+		   vmcs_read(CPU_EXEC_CTRL1) &
+		   ~SECONDARY_EXEC_UNRESTRICTED_GUEST);
 	enter_guest();
 }
 
@@ -9538,7 +9579,8 @@ static void enable_vid(void)
 
 	vmcs_set_bits(CPU_EXEC_CTRL0,
 		      CPU_BASED_ACTIVATE_SECONDARY_CONTROLS | CPU_BASED_TPR_SHADOW);
-	vmcs_set_bits(CPU_EXEC_CTRL1, CPU_VINTD | CPU_VIRT_X2APIC);
+	vmcs_set_bits(CPU_EXEC_CTRL1, SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
+		      SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE);
 }
 
 #define	PI_VECTOR	255
@@ -10395,7 +10437,7 @@ static void vmx_vmcs_shadow_test(void)
 		return;
 	}
 
-	if (!(ctrl_cpu_rev[1].clr & CPU_SHADOW_VMCS)) {
+	if (!(ctrl_cpu_rev[1].clr & SECONDARY_EXEC_SHADOW_VMCS)) {
 		report_skip("%s : \"VMCS shadowing\" not supported", __func__);
 		return;
 	}
@@ -10421,7 +10463,7 @@ static void vmx_vmcs_shadow_test(void)
 
 	vmcs_clear_bits(CPU_EXEC_CTRL0, CPU_BASED_RDTSC_EXITING);
 	vmcs_set_bits(CPU_EXEC_CTRL0, CPU_BASED_ACTIVATE_SECONDARY_CONTROLS);
-	vmcs_set_bits(CPU_EXEC_CTRL1, CPU_SHADOW_VMCS);
+	vmcs_set_bits(CPU_EXEC_CTRL1, SECONDARY_EXEC_SHADOW_VMCS);
 
 	vmcs_write(VMCS_LINK_PTR, virt_to_phys(shadow));
 	report_prefix_push("valid link pointer");
@@ -10475,7 +10517,7 @@ static void rdtsc_vmexit_diff_test_guest(void)
 static unsigned long long host_time_to_guest_time(unsigned long long t)
 {
 	TEST_ASSERT(!(ctrl_cpu_rev[0].clr & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) ||
-		    !(vmcs_read(CPU_EXEC_CTRL1) & CPU_USE_TSC_SCALING));
+		    !(vmcs_read(CPU_EXEC_CTRL1) & SECONDARY_EXEC_TSC_SCALING));
 
 	if (vmcs_read(CPU_EXEC_CTRL0) & CPU_BASED_USE_TSC_OFFSETTING)
 		t += vmcs_read(TSC_OFFSET);
@@ -10783,7 +10825,7 @@ static void invalidate_tlb_no_vpid(void *data)
 static void vmx_pf_no_vpid_test(void)
 {
 	if (is_vpid_supported())
-		vmcs_clear_bits(CPU_EXEC_CTRL1, CPU_VPID);
+		vmcs_clear_bits(CPU_EXEC_CTRL1, SECONDARY_EXEC_ENABLE_VPID);
 
 	__vmx_pf_exception_test(invalidate_tlb_no_vpid, NULL,
 				vmx_pf_exception_test_guest);
@@ -10820,7 +10862,7 @@ static void __vmx_pf_vpid_test(invalidate_tlb_t inv_fn, u16 vpid)
 		test_skip("INVVPID unsupported");
 
 	vmcs_set_bits(CPU_EXEC_CTRL0, CPU_BASED_ACTIVATE_SECONDARY_CONTROLS);
-	vmcs_set_bits(CPU_EXEC_CTRL1, CPU_VPID);
+	vmcs_set_bits(CPU_EXEC_CTRL1, SECONDARY_EXEC_ENABLE_VPID);
 	vmcs_write(VPID, vpid);
 
 	__vmx_pf_exception_test(inv_fn, &vpid, vmx_pf_exception_test_guest);
-- 
2.43.0


