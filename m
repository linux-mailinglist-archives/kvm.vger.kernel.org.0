Return-Path: <kvm+bounces-20292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40583912AA9
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 17:53:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA362288EED
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 15:53:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D28AF15F3F0;
	Fri, 21 Jun 2024 15:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WiKmeRH4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Y6ij7hDI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B7D15EFA6;
	Fri, 21 Jun 2024 15:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718985187; cv=fail; b=DCYeyXmnEefaHEjSLHr+xRaycalJd6iKccmaNdTSMyhUsF+TaaX1luFKYw5yK+dDO36VZpQIRhLyVHRSFbJxH/+VZ5jJ1ysn0t3dGMQyXP2aKnGZ/1xmFvuGd2H0gh13cp1X3rOZiBgZMa49hbe1b0q0BQncWOLANAkbUO5p9B8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718985187; c=relaxed/simple;
	bh=upDTZChfbVuamn5yNQLiNhAKXb0Zzlgt0mBP+0opAVM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=F354oxWGi4hHp0GPTBUq1mRez6eh91sIdrHdO4CY8fETXn8L4Hs0LTrdrbIjHLEdwQWOU1Nk3in+rwow0vDHBSUU5kJkQDsvFvEUrzwgY2BDbV0UpjskS09tr3xfEYfek4+07K0XyDFpl2oyeRNa5jX5MygG+4fMtDo+2I5x6g4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WiKmeRH4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Y6ij7hDI; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45LEXZjm010397;
	Fri, 21 Jun 2024 15:52:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=corp-2023-11-20; bh=9bTLbIEP8kgRFQ2h/JtxDkUk27l+0wng6iwtv20uR
	1w=; b=WiKmeRH4nRgI62P+VXdm4NDLlSxDiB6woFx8RfifZPczMOftg36WmwNso
	jZQs+Ctw1nGcB3t2msiEZXTICSLeptDW8oWWBSRudscKc2VUq/DLOW5526+Sp1BW
	uKf6xWOuLGs1uBFqHlAL7/dvY7nHH+aVP9irrt5ORCZ2CJzZfbggd/ueTOiFBWUr
	nz4i6z+q0bXQERVC2eiJohAAIE0+QF5SyrD51tjPhySvibx+e2nzrMj5929YM3Vw
	B/WTNL288RwriIFJJThpq5PGqVjEUN7haxfvO/2w19thDtOjXzWYyHEQ6pUdHsfU
	txVrEBbpAo2iGj4DXGHquYCGJKXJg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yvrktt31p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Jun 2024 15:52:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45LFLh5C019525;
	Fri, 21 Jun 2024 15:52:38 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2046.outbound.protection.outlook.com [104.47.55.46])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yvrnah2q7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Jun 2024 15:52:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GgNrV0o23qV47cryFvfXtkDgtv/a2HkdIYxQEBHtTe5zRY4jANrPAO13x8U/IaR6JlhjWTk8cXS1KXKU/HyQ0y5cFtjoS/VaKK5QkLDFFBQa5gBEaHCBAyOHrsuEhj51gvASvJobY8tMqa5ggmLgKr9Wa3AQFhycx//6hUqU1+DehxgBMGv4C7rrpqJ5gUZaXO5EAAqwuIlsN5kZnQVGQh9YDKFe+nKPvkA32xJlklmSE7XCcuFUxyIKd+TpvDnHrEzV/VCVLiqAcDHeRShDor2cWX/BvlZYKa4vlknV5VIV9ce1dGgGXE0DAUxv1/UGlp1dKhnfhnv+sPBHFmeTog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9bTLbIEP8kgRFQ2h/JtxDkUk27l+0wng6iwtv20uR1w=;
 b=iY38uCtV7RI9Qq+uo+KCXEjUeaJ4Y5O0FDT+PUPHqQu/q3tiT+vtuwoKEF4+tckrPRmJoJroktmWUufmhhpNN9HuPDrQmFR/4P0MDQYIWh8yIhOsNZJ+UpCEpBd/iWCypy/YChGxOFT8sAoTs+NC7EfNHq+aA8mzBzZc6/p884LU0o43wq+wpcinhuvttuGeh7HiuxAg0So/8v8jR7iLEYLDtdkUAFBHZslyHuC13TLgS2pdArT5r7GXJwCGQLb9K2p0Nkv8cbolw2dFBmhqjmIgwSq7Ck2CogJpqCRYSHA23O6qrfPiYRLUGwqKExL8pogyigWbq1WCPfRP0hvigA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9bTLbIEP8kgRFQ2h/JtxDkUk27l+0wng6iwtv20uR1w=;
 b=Y6ij7hDIhD3uShCfDGqrXDMyz1BQsqnL1g/mMNmJeapvNuW7Q7UxQIHpbivhGXvZrGzJNtks+vc/6JH45iwxTHXyu+OMTisv1oSfaLj1H0MtvdiddRPOd7l8QKVENQe1x7234i4IJdJLAfZ2C+2llmllsV9J9cOaMFhEg49qQ9E=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by MW4PR10MB6678.namprd10.prod.outlook.com (2603:10b6:303:22c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Fri, 21 Jun
 2024 15:52:35 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237%4]) with mapi id 15.20.7698.020; Fri, 21 Jun 2024
 15:52:35 +0000
From: Liam Merwick <liam.merwick@oracle.com>
To: Michael Roth <michael.roth@amd.com>,
        "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
CC: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "pbonzini@redhat.com"
	<pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>,
        Brijesh Singh
	<brijesh.singh@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>,
        Liam Merwick
	<liam.merwick@oracle.com>
Subject: Re: [PATCH v1 1/5] KVM: SEV: Provide support for SNP_GUEST_REQUEST
 NAE event
Thread-Topic: [PATCH v1 1/5] KVM: SEV: Provide support for SNP_GUEST_REQUEST
 NAE event
Thread-Index: AQHaw+EWUJDRODeMQk6SQ0dYhZmaErHSbWsA
Date: Fri, 21 Jun 2024 15:52:35 +0000
Message-ID: <8ac2b281-9aca-40ba-b094-165d18a08230@oracle.com>
References: <20240621134041.3170480-1-michael.roth@amd.com>
 <20240621134041.3170480-2-michael.roth@amd.com>
In-Reply-To: <20240621134041.3170480-2-michael.roth@amd.com>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-exchange-imapappendstamp: BN0PR10MB5030.namprd10.prod.outlook.com
 (15.20.7698.013)
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5030:EE_|MW4PR10MB6678:EE_
x-ms-office365-filtering-correlation-id: b6979ec0-198d-46c4-7ec3-08dc920a2b9e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: 
 BCL:0;ARA:13230037|366013|7416011|376011|1800799021|38070700015;
x-microsoft-antispam-message-info: 
 =?iso-8859-1?Q?jLtrmdwgOqrAbX1mDiPWeX14sQUb3olq56E22WttGXvmiKfse3FjtabL/F?=
 =?iso-8859-1?Q?7H0TcyJCyH3mXurir0hL/sxy5uV2jqLQqNrzFbxf3ztV6RYqApQ6lW0XcW?=
 =?iso-8859-1?Q?Y40COoYYFUZNE4Rk5HIW778BcV7402gCxwkXLKg4K/+lk4w9S2pCgBvyLs?=
 =?iso-8859-1?Q?tJQ5YMORgx6nPxbVLZh3KRys+62bDqs/N9iwwudXgjzVdfOntfDYCJN+Nt?=
 =?iso-8859-1?Q?WdiF5a7ObiEKLInptbuZU/rd+nEw4BDiCoGXb6grRZBoZsv6lSKzQLMl+4?=
 =?iso-8859-1?Q?14yw3ElrdCo5o+wURzRjYJ82ekEXAR8SaWkgO7p9KsUcMeXFy9dUN9u4cM?=
 =?iso-8859-1?Q?ljD52WxvPSY2vXMZpw0UI706+ehvKsdat1r9eWlgE7wLlMzUXX7h6ZpkR3?=
 =?iso-8859-1?Q?3njfftDlPnMZ713l2RGD5duzhbApwALH+2R7YR8VLnhbxOm2KjZWuyVveS?=
 =?iso-8859-1?Q?KJf/+HUofPbDEcpFgNDFWxtpCfmTuJoH85oeiU3Rticgd6aV7KzTmh0JU+?=
 =?iso-8859-1?Q?y/IQ8yIz0iZ6wH+bZjeSKLPOSRRBowk+0lA3wGVhM+oX0dlf2hvueG443a?=
 =?iso-8859-1?Q?6Fw7rlCgzeobu4MhUet8oBx6icdxHRoFRk8q8RFkzPJwNBtiVv+nE8C1vI?=
 =?iso-8859-1?Q?MQkJOfazWVG4+hN+7AaRz3Luu9sxw4js0mxiCLEBcz1qmh8v239ZQn9tv8?=
 =?iso-8859-1?Q?dn9n9fCRYb0XZGqtIBWyF6j9gAaXSJqxXq8f2XjVuyb00THILw5zNwOR70?=
 =?iso-8859-1?Q?7KIUXyrfkXT9YMzxD30clMxASdoGMGaNZNnhFSrNrlyyJzWpm4+os30VtQ?=
 =?iso-8859-1?Q?aeberDk3Bd9LX5pspXfyXycEh07MfHd4F3lvqv95AKt3yrRndCh+Z6LtoB?=
 =?iso-8859-1?Q?47uMGo5Db8ZEKpMP6k5mBFFyL/13NX+ZnlH/DmKTaCUkIsrTQKWS+dhBie?=
 =?iso-8859-1?Q?cvCUSZtJwIxHVn24Jm5Wuix0qfFQLf5yjSjOs80PJmIsv9tgDA3GP36d+a?=
 =?iso-8859-1?Q?MT4fQ2dCCrSZ5s+tIq2gTjz9GiDx2/UnRYWtH3Lp1ANoVhCr2lS4eTWcdL?=
 =?iso-8859-1?Q?+wzjKXPKJw97HuND+j2mCWuZqegwlYPSWtZvswhUjLlKqc0rElPT/8TZT0?=
 =?iso-8859-1?Q?3/5VZLto+l8p+A4x8RXlWOfBcn1RXuXyyzjehuQFR90JQFuKemFn/j0FGJ?=
 =?iso-8859-1?Q?B743ebqXadanOCMqBGcdMgN5G9TNkatv55zPUiBH7pYExNTMnFsd7fVc9k?=
 =?iso-8859-1?Q?Mg4FcleyKkJe6rgNnWmvHIKD9WeyCG6wOItUQ1BspDGmT/oz4MGkw5zs6q?=
 =?iso-8859-1?Q?P6LKeioL9hhSte/T6a9B/p3ZUqED5/6lOCqramJKgI6i5F+b1zd3ehAfPR?=
 =?iso-8859-1?Q?btG8EXj55RFnZd7NcTey9Y+CNiTFzliGKFyKHgPOyttG7p/jbxRg0=3D?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(7416011)(376011)(1800799021)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?iso-8859-1?Q?LbhzLl6269a797jcekF4GsjzbWTVvLDNmOddphGsYm0DhB/ynarmyNdIMz?=
 =?iso-8859-1?Q?v2/YCnDm57nT6Ql2DnYk7nS+YR4WiZMmZ2DFuvn6ZAzMjD18diUvn5pGJU?=
 =?iso-8859-1?Q?o/JRX51/TNpuDlWrs4bt1u2XViUJQXP0zGNCuOm5dkkgR48y3hh5Wb4YGM?=
 =?iso-8859-1?Q?qw4T5UV/tCSgUeJLYNgy6zJZkzGekx/HOJTJleRZdt/wkxAvJjSvC55RVt?=
 =?iso-8859-1?Q?hRtFHTuECRIdrnFpXyqTUfAvGeo/ryT+t3UmKg3fNifBteFcorS0AR4JDH?=
 =?iso-8859-1?Q?sI4VGTgGg5iwYXWgaEncTudtbD2b1PnyggZbJDipP8fpSRtHxKzmT5U6lG?=
 =?iso-8859-1?Q?HQez1z9AtChOsHbWJmVmf6idcOTRTN5EWerLfJs2IaSEFi47FHIuqFl0Ez?=
 =?iso-8859-1?Q?I/s8Mh4TsYnC13D9mmrlkmLi1/L0TPxMx6OF1k8vkocod2akDMkPQJQSvl?=
 =?iso-8859-1?Q?njZ7JSGlCLyz77iZf7RLhSyHdQHFIRZfcLtA/EQkYXaHv5Ssw4hEQqWruA?=
 =?iso-8859-1?Q?hQibxnhihwnlC35m5E/OmTILKEOfkuOXh2MVVtP49OgOnyVotWHhwfEU/U?=
 =?iso-8859-1?Q?AXi8xvgd1bojrCHNP94g1b6I3y97m7/B/M8oCV6DjLCSy7yWb+XPXxWe0L?=
 =?iso-8859-1?Q?tVXkzF1c/nk62caS24oFCtRaKiryNHtdb20obbi+Irn8qnwFle7sD7DLOV?=
 =?iso-8859-1?Q?XDKED0XfHZKfNJAevKr7kCwk/feNW0KZZ4ATNKYzvJ8Jpn+6o5TlOdyhpU?=
 =?iso-8859-1?Q?TL4YLc9H0b/pzvoe+CwvkbMC+rkrZBJWPPpDqKA4pdLbeH+A9fUPDmXBbK?=
 =?iso-8859-1?Q?sqddS1WVs0Zk8DScADI5rDCSF2P2D3+W5DT8P98IRERQWbDWuu8AcIrkVt?=
 =?iso-8859-1?Q?wVvdkD6Wpxf1ATFzc9bBpbJ5FjZTg4hWtnbTdDoEeD8oRaKmhOoVD6qQK8?=
 =?iso-8859-1?Q?1LAr1Vqh/xi4i7gFZzLthUnErQiUDN3dcDIIvXgIu62zu7yhu9/v1R1c60?=
 =?iso-8859-1?Q?wO24M4KMj3AsjVwmk/G0So399trFGqVEX5uEQw2BDCPyvhVCC8NmBMRi1E?=
 =?iso-8859-1?Q?olh/i3UhatykDjhzM4WZZSjGbjE+dwUmlVlCwI88GC306bby8fmBHG+/Dn?=
 =?iso-8859-1?Q?Mit2+cvW5NMrpTJ7R+vbI0lD6FqdupPqzBcvcvv/kc256MsUP83W/9acwu?=
 =?iso-8859-1?Q?pHuvL1uQ5FAyjzbFpgeFbNXveBgTu9oXaUrn8OFCa3ZWrxG5c9Mm/1049r?=
 =?iso-8859-1?Q?ZmgT40lZqg7ID/PUJS5zQ7JgWee/gT0y7KKdFd+4medVHTGEQ0xnXgONP1?=
 =?iso-8859-1?Q?xMvhnakQS+skUxkZFWZC5s9dGYb0udgkVleyUAzZOPYneQMv8LZE82pvn8?=
 =?iso-8859-1?Q?1YxzF6AeGvL7LF90cdlIx/MQOiRTgKBZZRMzS/bDC4bsZ0SwOdDhTV8nA4?=
 =?iso-8859-1?Q?1PQu1sMtKZD7yYx1WtdD53QUuuVDK3D0qaaQrK1KQUV1bTardv35Yj5370?=
 =?iso-8859-1?Q?BXDyKsg54QZyIu+Nld2+G7P42TIrf/2RlowgpQM6lj3GGyA08nzUFC8hZI?=
 =?iso-8859-1?Q?509Es1/h5FqNbQAI94mZT3RglFeDhchU6+J9lLPy4h2mviZWpsozmelQiu?=
 =?iso-8859-1?Q?P3Alb4xucYRIWO6gKTqAuaQ1tZ1DsTWlKCg8fcKSs25EXxsO7SYjikYg?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <18ED5D39B6B2B347895ED076FBB3BEB4@oracle.onmicrosoft.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	aOZbDfT0tC3uusXGgffysBU0mmK36IbNQxI0zN529jupLXxuCoBfMrosFfo72+VtYAbt9uXy/tgB4WmNs+q/5Lm+UNzaj7b35B2GUdJ+5K7hviuGUGq9/hH42/9c814sBEYhpqBiDGwHvtQ8C1KBfioj2usVNrjuR1+ZdRo5upuzB3lBUZ2oh2DTIfCovy25nJJ+bEVkVUTrNZ+ow90RDjO5BW4tDl6TcuBkyElrrSyid5plz0pFnfxiMDrrZL7fnG/hX+byxemOsRpVwnHQf5R/XvZyFg8PdQ9+B+1W+ia2fmcnxFuecn26zTt13KC45nOPAd6XYB9acYo+n1hcT/tEFF92c49JOnCEB9j967Yq3Fn+NNWi8UURZFchlA2Z01ww65WeCEu/W+bqtQJba3iW9n27GzKmlHPYTILHUy1iFYTVXIz7MZZr3OYh+stS/7F57VFLSLqVtDoCNZSyZUmRGA0qvwFL/cu2HdbdxJ8NmR+vCGMk1K5xKcsm4vzvL60eL6UPAGieL+TSoVvq1lnWRLaOflZX6tXwxUy85xW4jhWihLlrnBgVr43D2DbZknJnK3Ia3L0dQmd8VGFhuZTdwGBhYca7vZr9V2A5ggY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6979ec0-198d-46c4-7ec3-08dc920a2b9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2024 15:52:35.8530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9XTpZdHI+sVXr6tWOOAm4xqDwkz68v0bHcur4XwXpjrTcKQocJg2s3C6+IhgVR6c5rf95n5oerM6AizwpTcM4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6678
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-21_07,2024-06-21_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2406210115
X-Proofpoint-GUID: bLeMRxImd75ewMf8bIzFFLLmkASAAiD5
X-Proofpoint-ORIG-GUID: bLeMRxImd75ewMf8bIzFFLLmkASAAiD5

On 21/06/2024 14:40, Michael Roth wrote:=0A=
> From: Brijesh Singh <brijesh.singh@amd.com>=0A=
> =0A=
> Version 2 of GHCB specification added support for the SNP Guest Request=
=0A=
> Message NAE event. The event allows for an SEV-SNP guest to make=0A=
> requests to the SEV-SNP firmware through hypervisor using the=0A=
> SNP_GUEST_REQUEST API defined in the SEV-SNP firmware specification.=0A=
> =0A=
> This is used by guests primarily to request attestation reports from=0A=
> firmware. There are other request types are available as well, but the=0A=
> specifics of what guest requests are being made are opaque to the=0A=
> hypervisor, which only serves as a proxy for the guest requests and=0A=
> firmware responses.=0A=
> =0A=
> Implement handling for these events.=0A=
> =0A=
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>=0A=
> Co-developed-by: Alexey Kardashevskiy <aik@amd.com>=0A=
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>=0A=
> Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>=0A=
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>=0A=
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>=0A=
> [mdr: ensure FW command failures are indicated to guest, drop extended=0A=
>   request handling to be re-written as separate patch, massage commit]=0A=
> Signed-off-by: Michael Roth <michael.roth@amd.com>=0A=
> Message-ID: <20240501085210.2213060-19-michael.roth@amd.com>=0A=
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>=0A=
> ---=0A=
>   arch/x86/kvm/svm/sev.c         | 69 ++++++++++++++++++++++++++++++++++=
=0A=
>   include/uapi/linux/sev-guest.h |  9 +++++=0A=
>   2 files changed, 78 insertions(+)=0A=
> =0A=
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c=0A=
> index df8818759698..7338b987cadd 100644=0A=
> --- a/arch/x86/kvm/svm/sev.c=0A=
> +++ b/arch/x86/kvm/svm/sev.c=0A=
> @@ -19,6 +19,7 @@=0A=
>   #include <linux/misc_cgroup.h>=0A=
>   #include <linux/processor.h>=0A=
>   #include <linux/trace_events.h>=0A=
> +#include <uapi/linux/sev-guest.h>=0A=
>   =0A=
>   #include <asm/pkru.h>=0A=
>   #include <asm/trapnr.h>=0A=
> @@ -3321,6 +3322,10 @@ static int sev_es_validate_vmgexit(struct vcpu_svm=
 *svm)=0A=
>   		if (!sev_snp_guest(vcpu->kvm) || !kvm_ghcb_sw_scratch_is_valid(svm))=
=0A=
>   			goto vmgexit_err;=0A=
>   		break;=0A=
> +	case SVM_VMGEXIT_GUEST_REQUEST:=0A=
> +		if (!sev_snp_guest(vcpu->kvm))=0A=
> +			goto vmgexit_err;=0A=
> +		break;=0A=
>   	default:=0A=
>   		reason =3D GHCB_ERR_INVALID_EVENT;=0A=
>   		goto vmgexit_err;=0A=
> @@ -3939,6 +3944,67 @@ static int sev_snp_ap_creation(struct vcpu_svm *sv=
m)=0A=
>   	return ret;=0A=
>   }=0A=
>   =0A=
> +static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa=
_t resp_gpa)=0A=
> +{=0A=
> +	struct sev_data_snp_guest_request data =3D {0};=0A=
> +	struct kvm *kvm =3D svm->vcpu.kvm;=0A=
> +	kvm_pfn_t req_pfn, resp_pfn;=0A=
> +	sev_ret_code fw_err =3D 0;=0A=
> +	int ret;=0A=
> +=0A=
> +	if (!sev_snp_guest(kvm) || !PAGE_ALIGNED(req_gpa) || !PAGE_ALIGNED(resp=
_gpa))=0A=
> +		return -EINVAL;=0A=
> +=0A=
> +	req_pfn =3D gfn_to_pfn(kvm, gpa_to_gfn(req_gpa));=0A=
> +	if (is_error_noslot_pfn(req_pfn))=0A=
> +		return -EINVAL;=0A=
> +=0A=
> +	resp_pfn =3D gfn_to_pfn(kvm, gpa_to_gfn(resp_gpa));=0A=
> +	if (is_error_noslot_pfn(resp_pfn)) {=0A=
> +		ret =3D EINVAL;=0A=
> +		goto release_req;=0A=
> +	}=0A=
> +=0A=
> +	if (rmp_make_private(resp_pfn, 0, PG_LEVEL_4K, 0, true)) {=0A=
> +		ret =3D -EINVAL;=0A=
> +		kvm_release_pfn_clean(resp_pfn);=0A=
> +		goto release_req;=0A=
> +	}=0A=
> +=0A=
> +	data.gctx_paddr =3D __psp_pa(to_kvm_sev_info(kvm)->snp_context);=0A=
> +	data.req_paddr =3D __sme_set(req_pfn << PAGE_SHIFT);=0A=
> +	data.res_paddr =3D __sme_set(resp_pfn << PAGE_SHIFT);=0A=
> +=0A=
> +	ret =3D sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &fw_err);=
=0A=
> +	if (ret)=0A=
> +		return ret;=0A=
=0A=
=0A=
Should this be goto release_req; ?=0A=
Does resp_pfn need to be dealt with as well?=0A=
=0A=
> +=0A=
> +	/*=0A=
> +	 * If reclaim fails then there's a good chance the guest will no longer=
=0A=
> +	 * be runnable so just let userspace terminate the guest.=0A=
> +	 */5=0A=
> +	if (snp_page_reclaim(kvm, resp_pfn)) {=0A=
> +		return -EIO;=0A=
=0A=
=0A=
Should this be setting ret =3D -EIO ? Next line is unreachable.=0A=
Does resp_pfn need to be dealt with as well?=0A=
=0A=
=0A=
> +		goto release_req;=0A=
> +	}=0A=
> +=0A=
> +	/*=0A=
> +	 * As per GHCB spec, firmware failures should be communicated back to=
=0A=
> +	 * the guest via SW_EXITINFO2 rather than be treated as immediately=0A=
> +	 * fatal.=0A=
> +	 */=0A=
> +	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,=0A=
> +				SNP_GUEST_ERR(ret ? SNP_GUEST_VMM_ERR_GENERIC : 0,=0A=
> +					      fw_err));=0A=
> +=0A=
> +	ret =3D 1; /* resume guest */=0A=
> +	kvm_release_pfn_dirty(resp_pfn);=0A=
> +=0A=
> +release_req:=0A=
> +	kvm_release_pfn_clean(req_pfn);=0A=
> +	return ret;=0A=
> +}=0A=
> +=0A=
>   static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)=0A=
>   {=0A=
>   	struct vmcb_control_area *control =3D &svm->vmcb->control;=0A=
> @@ -4213,6 +4279,9 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)=0A=
>   =0A=
>   		ret =3D 1;=0A=
>   		break;=0A=
> +	case SVM_VMGEXIT_GUEST_REQUEST:=0A=
> +		ret =3D snp_handle_guest_req(svm, control->exit_info_1, control->exit_=
info_2);=0A=
> +		break;=0A=
>   	case SVM_VMGEXIT_UNSUPPORTED_EVENT:=0A=
>   		vcpu_unimpl(vcpu,=0A=
>   			    "vmgexit: unsupported event - exit_info_1=3D%#llx, exit_info_2=
=3D%#llx\n",=0A=
> diff --git a/include/uapi/linux/sev-guest.h b/include/uapi/linux/sev-gues=
t.h=0A=
> index 154a87a1eca9..7bd78e258569 100644=0A=
> --- a/include/uapi/linux/sev-guest.h=0A=
> +++ b/include/uapi/linux/sev-guest.h=0A=
> @@ -89,8 +89,17 @@ struct snp_ext_report_req {=0A=
>   #define SNP_GUEST_FW_ERR_MASK		GENMASK_ULL(31, 0)=0A=
>   #define SNP_GUEST_VMM_ERR_SHIFT		32=0A=
>   #define SNP_GUEST_VMM_ERR(x)		(((u64)x) << SNP_GUEST_VMM_ERR_SHIFT)=0A=
> +#define SNP_GUEST_FW_ERR(x)		((x) & SNP_GUEST_FW_ERR_MASK)=0A=
> +#define SNP_GUEST_ERR(vmm_err, fw_err)	(SNP_GUEST_VMM_ERR(vmm_err) | \=
=0A=
> +					 SNP_GUEST_FW_ERR(fw_err))=0A=
>   =0A=
> +/*=0A=
> + * The GHCB spec only formally defines INVALID_LEN/BUSY VMM errors, but =
define=0A=
> + * a GENERIC error code such that it won't ever conflict with GHCB-defin=
ed=0A=
> + * errors if any get added in the future.=0A=
> + */=0A=
>   #define SNP_GUEST_VMM_ERR_INVALID_LEN	1=0A=
>   #define SNP_GUEST_VMM_ERR_BUSY		2=0A=
> +#define SNP_GUEST_VMM_ERR_GENERIC	BIT(31)=0A=
>   =0A=
>   #endif /* __UAPI_LINUX_SEV_GUEST_H_ */=0A=
=0A=
Regards,=0A=
Liam=0A=

