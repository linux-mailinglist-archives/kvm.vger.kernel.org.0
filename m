Return-Path: <kvm+bounces-29446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78F619AB8E6
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 23:42:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BC37284CF4
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 21:42:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D6BC20408D;
	Tue, 22 Oct 2024 21:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YbQwca3/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YovNIuvf"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11280201104
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 21:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729632934; cv=fail; b=sFup62YuUqmGdy52bQjvPeU2nCpOqCWJfUb4BrycR44POhLLSv9omO8FdK00Xomg/T1bWBN+2bFz7eq2aKY6BTI7euY5X42ejGNepWPw6xoyxG9eM2vo9TfOj//Ldc1Rok/Ss1zxyWHnVRneeyr1wEI9xi1gK2TpfxSU5pheKuQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729632934; c=relaxed/simple;
	bh=LLg6IYE067oTSb6zrAoxXubqUb22F29KXij4rfbPAR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tzG+wPwX5JFl3g7g80Gd+slX285VcOu0iOo1QXuoixum2cfTwuStgVeCNFvIc5lsu/C4E2MQiFMBWfUtoMjTyEcKyEPO64XQZJMdvrwRhuYbzcrtRHwouU0wv9BlSGx5j5OoFHSjUTNCzBk6BkE8CU+8Xh2f4Fe6Zf1Oy17fNH8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YbQwca3/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YovNIuvf; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49MLQde6022788;
	Tue, 22 Oct 2024 21:35:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=peZGtW1XUChe8UkQOMR2jHk7QXKJujfjHK8amujyoCY=; b=
	YbQwca3/d6P5NmgLR/aKD55jCjuZosEh3cwRzVIlhYba/usTD3qDDqnHOtr3dOa5
	pyuSbXtVP5CfSX+ZRR51RlDptsVaHIAsFcW0vJ5S4g03Ty43NJbcq7Dqb3BLdjP6
	Y+de4FGilul2zN4B0pf1FaY6lB4ii6knbbje0tCdQfrpMVfGjY3TXKAwegAUbmMG
	xG0sq9r6AWCMreym+NFKET6D+WcZ3M/Y8rnjtx5wqnwogCrplU3HYmfO/5Ftt5Qs
	SWcM65SUQqngpkB0SnkXxTycIa8m6RRsH7HOePxkh716h8VzC+mFDaxECdsPlyBw
	4tr7Wwh1bhhwM2+LENi2FQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42c5aseran-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Oct 2024 21:35:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49MKeALG026254;
	Tue, 22 Oct 2024 21:35:14 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2049.outbound.protection.outlook.com [104.47.56.49])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42c3788nvy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Oct 2024 21:35:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=APzb4bbMxPnipI91P6AFhDvpemjjLbyL/qwpryatoBVBLSpesdAAmysmGhvv/sJmm1Dpo2b8fkua15pYs9ph3dKEmf458qtbw3r8vPv9jq/bZnQK8HoHNQvvLXyUHrRfb2W/L3vY7GrL0/X13atQh/wCqhNCgND11MQQtNKlgbSWSqPgpZQjB7gfMq83rwAfp+cjXMoxJPpRbZm7k6s9nVFzMX3lrgCE/rFxTKMD4iRVv54Cj8h9kEGRwnR7Yww3CLkAaqkEmdWc2cylmOhyJg6Q7XW/zEFNbHmjXNtDbOtA/hu9gekaPUIudKFmSySylZq3R0orGPpCknIPUQLdAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=peZGtW1XUChe8UkQOMR2jHk7QXKJujfjHK8amujyoCY=;
 b=Ed8dxcstzqyjpwSm69dfIk3kKc4jaRIGuYSKHybpJIOf3cy0FSdyPu4Bk+MY5YZg/Lhth20wWgyvn9eKYEicXHaRuwaxc0oWMRkygwC6SH2lS5vLyo5PbIQHTtr+sJWftkMDzIrEapb1MQ9sVrvCCCsa2dlQb7jPsC2D+SzkrcQjDA71b0+iYiNjoK5DVPgdHIAa28xbS9MjHsr2fapGKkJqxTppRmKwUCkWwz7L2gpbBZg5Z/UA29LGhkm67tDlt8q6f7sSxH26K2MEeNNaoK/hStvECVbTY4Bzpdi6vtvOUcjcD5eAsXuDX7kwOr0vuJhxhqA1KvFC77Dl0vr8DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=peZGtW1XUChe8UkQOMR2jHk7QXKJujfjHK8amujyoCY=;
 b=YovNIuvfOYNp3mYbeWXfaSKsc2JP27TG0BYXZYxDIsEq3rLKGF/wi+cJEz8kuneRF63ph05Q1+QQ1YpRS1AzgTk+KyThGgVW3V5kk8/VxECqp14bgMCtQ4D5OrAjyzuN8pQxZ+FcSJXcC5fPfmc/gOsbHOokhWlM2JG14W12pcg=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SA2PR10MB4809.namprd10.prod.outlook.com (2603:10b6:806:113::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.16; Tue, 22 Oct
 2024 21:35:11 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%4]) with mapi id 15.20.8069.027; Tue, 22 Oct 2024
 21:35:11 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: peterx@redhat.com, david@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: william.roche@oracle.com, joao.m.martins@oracle.com
Subject: [PATCH v1 0/4] hugetlbfs memory HW error fixes
Date: Tue, 22 Oct 2024 21:34:59 +0000
Message-ID: <20241022213503.1189954-1-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <ZwalK7Dq_cf-EA_0@x1n>
References: <ZwalK7Dq_cf-EA_0@x1n>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR02CA0004.namprd02.prod.outlook.com
 (2603:10b6:408:e4::9) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SA2PR10MB4809:EE_
X-MS-Office365-Filtering-Correlation-Id: 85c923aa-7052-4506-1a14-08dcf2e16843
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FlkYop/LE/JU+p2LsLZWiQsQTTGryqOGqevMUAalBVRG9ehIx+Js5K+bmDjG?=
 =?us-ascii?Q?nXnMIHFeKEi++XS8KwVvJ+5Ks2V8TbcMxBLk4hYgoSWkTexwF16m4yCxC3/k?=
 =?us-ascii?Q?Jmkp45EL2QwLL4485gFwmQahX1gqImbzejvQUrPZl68BL6cv0TkyjglDodWC?=
 =?us-ascii?Q?AJs3jBv/sJIXGL7da8MiDmFVCXCRBrSSwVmCbIuT11YGpf4uHzVR9gQcUcGG?=
 =?us-ascii?Q?ld2OeNREGrROe16pTwDwIvs2ASHZq4L44yVjZJg/7+Ad85vYFO1vhv1LOm0k?=
 =?us-ascii?Q?KmyZeQBnJzXWmlhPJYgSJH4kWcmL/5w8hBZMjORvLDLbShGDGk/2fr4qulA3?=
 =?us-ascii?Q?ByhEVwiEeneBhKmQldvptCwITxqcIRIbtWQ7C+2RyqbI49VcVEz80HJJO5mM?=
 =?us-ascii?Q?s/70F4KeBau7yFvz+p5xjXAqbm5gVX4FhfQJXYzGAzmhvaIJZMxusMmEyADQ?=
 =?us-ascii?Q?fF5cW+2xwj9aDs+ZgO/2Wb+uU7w0KAWRDicEUYay+8ZsRnSCN8SUCoPHUbX8?=
 =?us-ascii?Q?nHr+1EznsLXTHJS9WSsYSEkwChW+LE9pCnj4zpwDOGHVjWK+zEge76+zA+hd?=
 =?us-ascii?Q?vX4IAhNYGp5ikrQQY4qFN+hM09LGq4RttkXjpmYsgxfNYt15VYV8MAappLPg?=
 =?us-ascii?Q?XD/2KTDJCjvG9Asf01FJj/bE4lEl8onrmoG82y17u7DTsBtcBRhDIwC7JnBY?=
 =?us-ascii?Q?rMrk6deX4njwpjYqCW5DwtbAjiBwDzwHHYJ4ym+u6/6ifxh4Z+FPpOkm7h72?=
 =?us-ascii?Q?1uddVkHxGQzIx3w/57MjFOdlwQIticNEhDWy53maskux7z/U/cWx49TXPSxw?=
 =?us-ascii?Q?XaFfie/S4L5lvQgh4z9dqWqGgzsxGRqhkc1qsC26LPSiDr8Cv+43Np2FWKR/?=
 =?us-ascii?Q?Sr5EDvLOzwBx5PuF8p4fmmvRfVh2HVQxebgtjALDLBrNOs6k0B3iyYDf3rmj?=
 =?us-ascii?Q?8iUr1U/lhO17gk8AnboaAKRXspGDflt/coF0tDNCfhk01bQWx2R/25Jsf6o7?=
 =?us-ascii?Q?cR5XyOBWZ9ok466Tspio83PcOaoNJ96zueqZk4QI2q56pWI2PA+HHYQNzIdl?=
 =?us-ascii?Q?Zeb1pWWRBj2419Qe4D6zHzkliAe/CaBC/SK+JT5i3hJJgrWydjswUF8eYNxR?=
 =?us-ascii?Q?Zce6oLmANlor9erLbetBZMNNypDp2IqOLwdCyerMnh9ZxxVY4pfsFG0leZc4?=
 =?us-ascii?Q?Xp8bgik/fnhpXUy7PRdEN3OcogbFuzqQbJAKmAs87kJyGHtxQ7pjO8M+7+wr?=
 =?us-ascii?Q?xW+G7gUR/nYQ9nlmkMwN1prH2DfsmzsSce1w/JcLfD0J3KxA6zgc2ohCuSCr?=
 =?us-ascii?Q?a0vc+7x+2TDto5f1hG4ngidWPm9D3B+dh5LGgaZcRhoVK+sfEdN3Yl4n6XiV?=
 =?us-ascii?Q?W0zYZSo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dZNeDzhTSnBEhr4GCPTM4XmPhDOqEE4WaVdtDJ9OSQnTbmQFtQwaR0wBxuvM?=
 =?us-ascii?Q?pYmg1LPEgW14xe9VimBIp/AyvZ+j/2gO8TP0+tsrZ5n5wDNV4stJYiFSyfok?=
 =?us-ascii?Q?FjFEVjQh6IGx8/l8ruFufrmwqPKO+QmWAo/bqSx+Wgo4pMtoA3dyGtijJNw+?=
 =?us-ascii?Q?FgwnTB5rnI2qAJLcls8NSWfhkS+HPxvEttWN/HbLRi0hgKZVPuzOBTf7pVEB?=
 =?us-ascii?Q?uKUPeEJ+Wc/io7XowOaNmXg0gY63YowMGiYHeUMvv9ReGc/fzTW/PkZ8xqvn?=
 =?us-ascii?Q?hSyAXkG4j8GFpwh74eAqD4+FqFa9nq8rYkQVjNSH58aJ5ph3le6a2rlVj7yz?=
 =?us-ascii?Q?XeKF4fSkRp9X/8umJApkCfWMMPFWJVPKyLbZRzNdh59v4dgeuDWpHxrWd7/u?=
 =?us-ascii?Q?9+eXVd/X/8JoXPfgAIq7RN43mg7GTw7TtYb1TwVSTUTG9VSoHIgdg/bXIx0c?=
 =?us-ascii?Q?W60wbtwUeQlmw37h9642bJnwFvrbeu0NTvS2wMedSenvRQDBu+3xqe/Y3ilg?=
 =?us-ascii?Q?a5t5NG97+6YjO2+PcX4r4/N1lB35hensup2RurDJkcolNSRNooKC6pyDfJMg?=
 =?us-ascii?Q?Kyk13OXbpy71uCdWuWqeTWx4Hq3xYDPgMIMYWJ56ObhiB0e61TaGDQCfynfo?=
 =?us-ascii?Q?eVdnX4asXtEFQKCm5xS2sqvgiC/5xqpu+R1thpigvGvSpdYMaJIZbh18ksap?=
 =?us-ascii?Q?svj7D6CnYNrrdtBQN8NwaUCYi2iw8ZjZ3rf3LndlWFMb73f/Xaj1LaGGR6lU?=
 =?us-ascii?Q?I3PaHm9EXKpRj34xxnzf4W5XS8c1YI4L8QzEZYenf14dTBAkgcG1uxfP9uqy?=
 =?us-ascii?Q?0V/9RS2nEpYcLrXoDcgQAYhZ/UyUkX/VJZLtpmM3pZvPslRr7YAvEVYo6BvB?=
 =?us-ascii?Q?vXO+UxsqR1tceacxXuiS8jkp/6MdtVmoKtuRJl5tzMClD2u9Wq+3DSRrp/01?=
 =?us-ascii?Q?npYu+qRhxMXlES7icwZVsDe5smRd7DSjTr2LAIzKsJ3nGfvYmQCmvg459xj2?=
 =?us-ascii?Q?IiR/qfYE+zjf4xR62fwjAGKY8feBYjHvgm2L92zuGVBE6e1o+W8M1KcDO8pe?=
 =?us-ascii?Q?WLe6xJhxWMu0Hp41MzwZbSR2eSO/wGRvclG+GWKgwjlspTUG07m1UEatcFYy?=
 =?us-ascii?Q?AOE/ylFSTak9wy60MN6+FwhNEE5g08TslVlXUglEL6fPjIU1VX4SYdX+3FFu?=
 =?us-ascii?Q?4fZW+ZIH7H7K1vhKRU8pWCehBs5VUU+CsAVnymFSkC0yD+Z+P1tacLwOpRjy?=
 =?us-ascii?Q?atn/BgVcLtpzsiiqLiQSWj+gpPQk4OfZKwqIcIsHv3Mc90NvGWsZWixrvxFU?=
 =?us-ascii?Q?Sq1lqdYrgNBWr2VJleiW2q2i1MyouoAk4JkoCK4VPkis6O0f+ajQMnajiAy1?=
 =?us-ascii?Q?d0Rs8rQUXXcROV3tv9nk1FPa3GvwXSYRPDVpTbBc5ax0Pf65gbrmWEGzCuUf?=
 =?us-ascii?Q?ptG4mzidLKhZ1mODWSQk6Vj72PO5VM/AT4SmhpGKDrAqSQ5jeq/8LFQ45xsO?=
 =?us-ascii?Q?ik5axehT5o5dJjWoJ0rNLI09WswZIsFAGmoZTwExLfoz398MYXZvlsRxE24t?=
 =?us-ascii?Q?jU89WrqAohtlw+ORgfe5F997QjpTM01bx47jDkp1v7gKkfFMGapn+4C7hGTE?=
 =?us-ascii?Q?Iw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	f2sY3OTStupqxeEb5URIrInmzwgW+DQlqMvzt17PTYE5fNzGwIgVYlg4ddoa3722j3ydrNrTo31uZ5tXkMpZX/dnBmFKyTSaYfDhdQn71oqZolPXxHOcsqyNeJFozP3wMpUrsPeUON9S76t3HkuVUyR8+oEVcUTgkRhl90c1ulRwc6qB2BKJ0BU6ckr+M5TPC1x9tAM0qCkd2t+lt1uJ/4WielOxUpsMOxlm5MxiwZHuyHI9MUs5/x4DOh9z+89N+yFYj/gfb9XlpTEpKKorbIw6rLXy/93zlMVQmfLupPYg25PFlUJbyxcF6K2w00oxJHWseuYBg5LWNe+pEivryy/+aR4jNgzaFtzswmS5D9Q196KLCm7e6ATKqHhulKfL0D8KI9OcRDvuEal+x4aLKc3mY47xnGf+jTrtSMCWB6ul/4u2/Zeyiei4z/g/A9E4D5NtE7Ut78u/s4YBm5tovr9Ayil2IdRngcZgvRrzTiKHNvte/rRUkO2NlWawhI4yppMDXN4LmiP56PMDSMetSlTmzETjsiuZuzCb7yUwR2bz2tsT4tIkH4ecIQkhNgNn6gxO6r5Ec3lHllomJsTKWMc9XjT9EqHB4g2pParcF/E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85c923aa-7052-4506-1a14-08dcf2e16843
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 21:35:11.2859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SoOVIf205+CRjKHZsbH0SV0FnlQ9hR38AnskmWo/X9fPvHo+omt/LXzskOxtsq5F+MbNd4DZHi1E63MEDYp7RxqtBmWA2zJG58d2zbpkZYY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4809
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-22_23,2024-10-22_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410220140
X-Proofpoint-GUID: G2Q01AfEuk72ideQOScPkTfuOiPWEqgX
X-Proofpoint-ORIG-GUID: G2Q01AfEuk72ideQOScPkTfuOiPWEqgX

From: William Roche <william.roche@oracle.com>

This set of patches fixes several problems with hardware memory errors
impacting hugetlbfs memory backed VMs. When using hugetlbfs large
pages, any large page location being impacted by an HW memory error
results in poisoning the entire page, suddenly making a large chunk of
the VM memory unusable.

The main problem that currently exists in Qemu is the lack of backend
file repair before resetting the VM memory, resulting in the impacted
memory to be silently unusable even after a VM reboot.

In order to fix this issue, we track the SIGBUS page size information
when informed of a HW error (with si_addr_lsb) and record the size with
the appropriate poisoned page location. On recording a large page
position, we take note of the beginning of the page and its size. The
size information is taken from the backend file page_size value.

Also provide the impact information of a large page of memory loss,
only reported once when the page is poisoned -- for a better
debug-ability of these situations.

This code is scripts/checkpatch.pl clean
'make check' runs fine on both x86 and ARM.
Units tests have been successfully run on x86,
but the ARM VM doesn't deal with several errors on different memory
locations triggered too quickly from each other (which is the case
with hugetlbfs page being poisoned) and either aborts after a
"failed to record the error" message or becomes unresponsive.


William Roche (4):
  accel/kvm: SIGBUS handler should also deal with si_addr_lsb
  accel/kvm: Keep track of the HWPoisonPage page_size
  system/physmem: Largepage punch hole before reset of memory pages
  accel/kvm: Report the loss of a large memory page

 accel/kvm/kvm-all.c       | 27 +++++++++++++++++++++------
 accel/stubs/kvm-stub.c    |  4 ++--
 include/exec/cpu-common.h |  1 +
 include/qemu/osdep.h      |  5 +++--
 include/sysemu/kvm.h      |  7 ++++---
 include/sysemu/kvm_int.h  |  7 +++++--
 system/cpus.c             |  6 ++++--
 system/physmem.c          | 28 ++++++++++++++++++++++++++++
 target/arm/kvm.c          |  8 ++++++--
 target/i386/kvm/kvm.c     |  8 ++++++--
 util/oslib-posix.c        |  3 +++
 11 files changed, 83 insertions(+), 21 deletions(-)

-- 
2.43.5


