Return-Path: <kvm+bounces-20294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 40B8F912BA1
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 18:44:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64B581C26358
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 16:44:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BD86166317;
	Fri, 21 Jun 2024 16:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h79oyTof";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RGiedUQW"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703DC15F41E;
	Fri, 21 Jun 2024 16:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718988223; cv=fail; b=q2+ptOkk5TK7/+HdpJ5s1a1yQG0LgYGTJmm259mJhUexMJ4VARRk6K70yUPhBrHFv8ArDC6U8dxks9RYwrMfYWLpm8A5tUvWxh7Juyb9fR31HUbriyMuw17c/tVJvd0dQ/N2aVDtSOhaxJjjVNnGgEuPPt51LIfty3LWuyQaC1A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718988223; c=relaxed/simple;
	bh=QTTDg6Iu7GiB5SJ8ovHziolZLevL8e2/NnGZflC97Lg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=t4kS+tVESgVaUDyKF9DjFS3t8pCKVPB28BJbGQS1aJ/NHDzUIGKlhoxZSmc7JTJaEc6eIhlzxxIxUkaQzJUP6fCRguGh+Ei6w8+OCkDnL6Uacnw0YGufF/kk2iyNP7e/B3N0JbIkHWqdff7fuvRRqpcTFlbu4lcoJYh6D3jORSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=h79oyTof; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RGiedUQW; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45LEXSkG016892;
	Fri, 21 Jun 2024 16:43:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=corp-2023-11-20; bh=BPKwtkJDx3ViYcfFHIuFjIK2hZdzjC//YNGAMjA8W
	iY=; b=h79oyTofgiZb3v7MTjJ/uHOY5hVqr5IXHDHYRclW4nUo2PkSy9JIYCByt
	EBYVS3CNNOHAHxS8uRbNlCE8wblp8/T0l9QhSSdjc+gqrvujpJXfiPGCCW1yQVlv
	CXoYg+vq/Ckm81x7ufKQXPj0Ki++tb2P9L0B2Eq89rGGfVrRZsSMCxgOGKPJAcFz
	2eP/xtZLANm/9m6z2YxOXeaHueOS3Kq1f/C3AURYZs1NzueVT4YUj4CwLfQQjAEP
	VUg8waV+kzdskX3nU9x+AyBgUYVl+fz1T/tntOdleUM2k0xC++/o9Zpw3yyQybcE
	BzluRz5sfy3R6NeWaacdtUyTqrgyQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yvrkgt61d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Jun 2024 16:43:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45LG5DBl012893;
	Fri, 21 Jun 2024 16:43:21 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2043.outbound.protection.outlook.com [104.47.70.43])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3yvrn4w3rc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Jun 2024 16:43:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wjj4BImXHS4bYoLDWVX3gOfv/SIp37NjyGCdoxdPyVuRmTy69VBLFsVYnYm+uWlpeUNuVrwHjUYrqwKXaEScZ69Hj45bEUTdkAjaoE/UkNDsRC0c+U848XmhEoh24LiIfXRT4+BKRO8Whh5fotyqrmVg/mkzauSt7lRe8gkH02LwkhKblhDQdh12B0q/7KWfNNISg88JTDcLqSqn6HWZ/SOKbqfv3pBOWw2mWQpKLvOdV04NbqzF0eACjSD6baemaGCCMdY0oCbN4E+/egmAMSSQvkYhaXnOuLxpHjpGG0eCzByjAQ6oVEPj9HUw2CjM5pIRn4K9qVN/nQD6KgAWrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BPKwtkJDx3ViYcfFHIuFjIK2hZdzjC//YNGAMjA8WiY=;
 b=GtCtr9wRS3ggXLzE4betLfmQO1ojZXidsX0UWYX/XJBa75YYMMucKibArlNYkM16c0nVMT5xqXpHFC85JncyjrQmYf2jw+fy3mw8xSOmv+yzoy+rY0N7QIYFmgz7YlaevdFmuXCXJjrojiSSgtzentxaSmP0Hc99cJX3fjSisU7VsTaC71EOYR/9OecKB1Ea9s1NHvmcBiLsq9YuoVrGSK613Bkjs+sa/Y03vfKeyzbdeEQyR0EYMHIcai/3T5XLfeMkQsNiUglICZgRtqihJM+npPwsiF7cDv+7h1D7NFMI9hh8S8THDCsomFldfS1pKLw2VwS9DKJIaCJ271gTSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BPKwtkJDx3ViYcfFHIuFjIK2hZdzjC//YNGAMjA8WiY=;
 b=RGiedUQWb3E1IrqAvzQz0NVLHZ/zoiP4nVcJt6yZeABvfZ5/YF9SEeiPBnQMfd70346XT4zT008y4BFIhNbY0oy7G81S1sqF78c9YcS6uEIFDXCMRUuum9O9+yN6rnuVsRkCDCK4ej2LEnbj9CtWT+FdKM+GMPlLuKpbX79p7vs=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by SJ2PR10MB7059.namprd10.prod.outlook.com (2603:10b6:a03:4d2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Fri, 21 Jun
 2024 16:42:57 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237%4]) with mapi id 15.20.7698.020; Fri, 21 Jun 2024
 16:42:57 +0000
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
        Liam Merwick
	<liam.merwick@oracle.com>
Subject: Re: [PATCH v1 2/5] x86/sev: Move sev_guest.h into common SEV header
Thread-Topic: [PATCH v1 2/5] x86/sev: Move sev_guest.h into common SEV header
Thread-Index: AQHaw+EhLAgjX5XMtkKxcjjJ9SUdX7HSfJ4A
Date: Fri, 21 Jun 2024 16:42:57 +0000
Message-ID: <191d29ef-0539-4e23-b004-9ce7a9b63aa9@oracle.com>
References: <20240621134041.3170480-1-michael.roth@amd.com>
 <20240621134041.3170480-3-michael.roth@amd.com>
In-Reply-To: <20240621134041.3170480-3-michael.roth@amd.com>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-exchange-imapappendstamp: BN0PR10MB5030.namprd10.prod.outlook.com
 (15.20.7698.013)
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5030:EE_|SJ2PR10MB7059:EE_
x-ms-office365-filtering-correlation-id: 0be8fe69-c89b-4db2-81cb-08dc92113477
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: 
 BCL:0;ARA:13230037|376011|366013|7416011|1800799021|38070700015;
x-microsoft-antispam-message-info: 
 =?iso-8859-1?Q?hiZsUn2NBA+sxnQTK0s/Y0qPL5cb8MZb3Ny7vgMrLCXDfARJYXJ0vXVBP4?=
 =?iso-8859-1?Q?JW923uS94R1nvXJCVGjFE0uAm8dWwC8QF0eT/XVUqFvoWnI9jeCi6LuJ8p?=
 =?iso-8859-1?Q?u6rAg5JvJ/tt195lFJgfAOG41Njdydw0vIz7tD8V9YWcpLpmZnfukIumyG?=
 =?iso-8859-1?Q?AZ9Pl/Yy6brrXhyiFA3wudQzoEhON/55YAKVIHhCPgp21CEyJZSoH2nDnQ?=
 =?iso-8859-1?Q?bQ9sEEOwjs7LoDF/J77V0fJRvMjBwKPIoWBZnfFgPF6YT05YyY1dwAIPxH?=
 =?iso-8859-1?Q?0ukPepuK6RVJAAPANEROAasDd7c2wvKDtnFO8ifnU7BjsOcxBVYTcs36eH?=
 =?iso-8859-1?Q?XuK2Edb9Uz6nWFMhOKyN/WxgAwNrpoQBEn0YrXBLnjmhiUmk3kHu9sXxZI?=
 =?iso-8859-1?Q?Idjm6lZHOFGmRN0aQvEGTYS5o86iIqXO632pENt9qPTcBiS6OD+upbi1Zg?=
 =?iso-8859-1?Q?2C/CsJ19ON3z28+K9Nxua2vamJVh40P1IFyuBRXMVXQifRcMRbI63zGFr6?=
 =?iso-8859-1?Q?OuJokAuFtv1tMkZKhl0z4h9aS8xvlmZUcOUrGmaE1osQRV6JG2s73FULYe?=
 =?iso-8859-1?Q?ccbA9N294sC/prtXK+SyGnl3hY63zLRjBtqDRf2A5vy/vE396Qn2cFWdQH?=
 =?iso-8859-1?Q?rUPZYDraTi6tWJiv7nBXvyykIbtpTqMdcDlLWUxs4DjWifOkgPRnP8XkOW?=
 =?iso-8859-1?Q?fqRu7kntc8fF+5ZmlbPQwcQ9O99mjiqUXySZXlF961lRvYauYrhLmVCE5d?=
 =?iso-8859-1?Q?lxHlQeaLOZL/oLj/z/fcWJJJ9MpMkljBnLAeO8tXbDLbcX+2AGJOF5imJz?=
 =?iso-8859-1?Q?aPHdN2QLkSFk5KBJsnUmARZWykH/qR5QohzJl0sYWIg5h50Kr5JmcKma5c?=
 =?iso-8859-1?Q?/V5BIit79VqbF4bggxXmjY6AHN1htw+18SZCeJyRIsx3nUaXer8eBmG39E?=
 =?iso-8859-1?Q?XAhlWEYZTs8oeLA68CQ8m+659uLpYT2YIxqH4B/03uT2NueESoraJ2UBKB?=
 =?iso-8859-1?Q?wFSDPxRi/Qm0mNG4/c1VAD/PJEYmeMjjkilNKPr2IDoU9WrG/0i5QX6k9I?=
 =?iso-8859-1?Q?p6JYQLynklc3eps6NnkpBZG5e+QqqDNaIHgG3+0iGvaliRwtiH62jeW5x8?=
 =?iso-8859-1?Q?70ChMaZ8ReRJeerKaFynEB8hm72qJMhoSKOBzWoBpvrHjJSvrq3XrkEwCc?=
 =?iso-8859-1?Q?0wA1k6bb1iRV2GEcmJmxO3bPPhXEdBJ/6Y/+2ue6xTgBjK4AYwK0BlO/Pa?=
 =?iso-8859-1?Q?ypvKzi20nw5HU4frn+pjWIHoW1L5WQE78ybRRtzHjWCtEZlvJeev4Jx2P/?=
 =?iso-8859-1?Q?oqDI/r/MUqN/KbFI05zQ0xWFZOqhVVdN5gesjok7CprSl6MPyh48e6n3bO?=
 =?iso-8859-1?Q?sDAC5BCv0Gn+XPpsf4hK0ln9CEhOLCKgF+pthxr9Uwg689ukBp4bo=3D?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(366013)(7416011)(1800799021)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?iso-8859-1?Q?3c3ZaBsvJ5CSN+hm6FA84s5pkk3KqpRM+98xThAMhYEHUTdrc6yKIZbY1H?=
 =?iso-8859-1?Q?jobO/BUcaUY/ISlfglg/+lDVFEyUtuEOtCqjk4zMRj8C9sds/fEmKgH4FI?=
 =?iso-8859-1?Q?/oiE3lKuf67n9CsIGvQkUcbSCdJT92cNGY4zYwUlaXBpAjYmj5z34GzHcy?=
 =?iso-8859-1?Q?w8ZvKpqHd0Z+LGEFccsrgDkJBNMN+Vmv2HZ1bKpzncP9OK/yhxeDFP3rrJ?=
 =?iso-8859-1?Q?FpYhWH0440RN3S6zq1Z14GMZ9oqr171VWulycf2Wwf94e8pz1gbgqEeW8g?=
 =?iso-8859-1?Q?DoptiK353I3iwtMIGF+KvA+SiQh/8tEgcUu1RnPv5wfurOOH6f7+TLz/o5?=
 =?iso-8859-1?Q?zAYETyVD1kzSLuogIfe63S3cO8lNa7y7kFRgVYrqMkUq6tAdgZsA6NHgak?=
 =?iso-8859-1?Q?Z7A0tocddp4QnNuBXGMBGybzjaBoBs1Kch0igR09gzL4+pQdhse13JgEjq?=
 =?iso-8859-1?Q?cJijX23AG1eaXjNifwLc6U+XTIZA36TRi9R1AX6FhHAxhTwUtM5ZaUfi7u?=
 =?iso-8859-1?Q?SQfLtN6MkbTCBFxDUHF8yXI82NQ1Rd7m1bnqQylSk0H0Q9w20JBBgFpxoj?=
 =?iso-8859-1?Q?zAE4t3x2uGexFfjOvE9TgQxLEhh54UJmtXpSRKCO1dtKobPcTdw2vYbEM9?=
 =?iso-8859-1?Q?f1IbIAo/aw9g58gvS0WRbLbSaXhRQyYX9itjeuP928kmTYagind5Q9dr+Q?=
 =?iso-8859-1?Q?HUV30uc2OpFaUWZDbmQOq2QDnxWNdiJN1AzVCG3Ui5V1kxat86rkk5jF4z?=
 =?iso-8859-1?Q?NdTWlq4WSHXJn13fAFI0kqoEMtVLCIU+X04SSCCp7R+MarQbnLep9cFrDs?=
 =?iso-8859-1?Q?n90TFGCl4IVyg0Mg6/vGPvZ95nXOx8ApkogruPEC2p73XziEBfmT+Pia1S?=
 =?iso-8859-1?Q?su7DUFyClJnciqlXpvk2a0vu2OWn+LR923MIOaHXRP1/nuJS1EDNZeAEUz?=
 =?iso-8859-1?Q?tluwu5IuhyG4qy4vohc2UspNKAQDcBP6RtB8n9QBtAaUuYFxnb4ml//jQA?=
 =?iso-8859-1?Q?/QOmSk+zNDWIWuLqrzYtrHyUtzQfj4Z1LQ6nYBBvc734G6LcLa2hAgz7ie?=
 =?iso-8859-1?Q?aUcpvsccuIiOV2cU5CUK7lkSrm2jLWbcWosHA7Ms9FzUS8Jz1GyIMuSZFl?=
 =?iso-8859-1?Q?FrK1lAzzIjo4t3ftvAUUJWUy4j+VKKnUokeZVjxwmsAy3Ek3HNtRSNZMNz?=
 =?iso-8859-1?Q?PmusiS9oyn9yRnojURHCNTXAhYrQWwdh9Z7Kx4Ki6EkjC10WHtO121/O3M?=
 =?iso-8859-1?Q?lN3LJZ/LpI8J6gOeookKUQAby7VKdL56oIsniWUYa3+RHAkblr4juMYupO?=
 =?iso-8859-1?Q?bO2H7AFg1AJzKB76phNoX6hc4g2bGJ8O0CsG/gEc50aq8RsC69NW15xlha?=
 =?iso-8859-1?Q?XmV8ccIXunz4nhvBylY4h28mTsyiVyTCUVeq69nJ09Z9LGil99L2deKYyL?=
 =?iso-8859-1?Q?u7qBmFnvuZviFaTgGoQjDiqW2GgVUb2FNrU5RvALI/B4CCLy63A7pqxOew?=
 =?iso-8859-1?Q?tIbSZiWwHU3B8i0EUqXznqIEi1JgOr0dOkGFrlUioMZTdGdD7/6NLP8wQJ?=
 =?iso-8859-1?Q?zc1ji6e6VmJcKXYu3bDvMLOacxoT1I6NoZgaxCJhkkVM34LAq5w72klSTu?=
 =?iso-8859-1?Q?H+5E1TO9bUNnf+Yd+tT2SCkuf+wRdhg5hEeDH0BBx9G436a7uiPw+q1w?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <CA09AD93F6538F478F701C236B8761FD@oracle.onmicrosoft.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	vhLewDrN5ObiXRl7JdeK6hkQVSauxsvw9IFEc/IKNLts80cfDxMMgVPwFtOCN3zDF69RUufqQVBVtB07ZNrqW4Unb4cr+vrnbmpQeZtXQy9rrzLW7ErCkfN8+n58KSlGbxM7jC9yTuBfvhWOnDvFaz2814VGhcoYld42X1LZTx75gYGFhPiQF2yd93Yi+0GiCG2uw6EiGXRCM1azRtaiYWimQFPjmmIYKhrBhXcdsWfV5v7el4KLHn7EpBm9lQJ5AImMZTWZi4p+++sOG+cc/HNJFc1SXY1H4PFdnhWEKI3CfLZxnzAdyUnd9iD17HfK5aT8haGQgiAqRrnsjvQJG8neDM1x0J8qvhc58t08ZeAG/xxeRuca1DCstJW8I0C3oIBmtiCGCbOLgZJfLLkZG2JlWJbW/FUdSvwxdDmh4Lf/Esae9zprji8Z/+vCAhM5ZCNafLAP4CTuVPbtxJ3mhN40msWyhQ4S6AlYEcZYgGWvPVOqm5/AgtHRmDev6ntLxJJ8pTwm0GCYXih0N15+33eAMvS4jkIDPAJT51bn/u+jPgWffw6LUFoaN1kkuJyvE7hBeZYQLMAymZZn8W3lycR3eQIq2IKmHyGnx6xmql0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0be8fe69-c89b-4db2-81cb-08dc92113477
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2024 16:42:57.1521
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: toEVBUuf6lEa9RZNLO02yAvDyfU6s8fQdXtZagDKoeU4bK70rnUf8+/ww3cEFoigcm9AkBUxpryNeUXYocqF6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7059
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-21_08,2024-06-21_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 spamscore=0 phishscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2406210121
X-Proofpoint-GUID: p5mZAqb4cQ6LUO2riKbaXCE8g9nVHvUo
X-Proofpoint-ORIG-GUID: p5mZAqb4cQ6LUO2riKbaXCE8g9nVHvUo

On 21/06/2024 14:40, Michael Roth wrote:=0A=
> sev_guest.h currently contains various definitions relating to the=0A=
> format of SNP_GUEST_REQUEST commands to SNP firmware. Currently only the=
=0A=
> sev-guest driver makes use of them, but when the KVM side of this is=0A=
> implemented there's a need to parse the SNP_GUEST_REQUEST header to=0A=
> determine whether additional information needs to be provided to the=0A=
> guest. Prepare for this by moving those definitions to a common header=0A=
> that's shared by host/guest code so that KVM can also make use of them.=
=0A=
> =0A=
> Signed-off-by: Michael Roth <michael.roth@amd.com>=0A=
=0A=
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>=0A=
=0A=
=0A=
> ---=0A=
>   arch/x86/include/asm/sev.h              | 48 +++++++++++++++++++=0A=
>   drivers/virt/coco/sev-guest/sev-guest.c |  2 -=0A=
>   drivers/virt/coco/sev-guest/sev-guest.h | 63 -------------------------=
=0A=
>   3 files changed, 48 insertions(+), 65 deletions(-)=0A=
>   delete mode 100644 drivers/virt/coco/sev-guest/sev-guest.h=0A=
>=0A=

