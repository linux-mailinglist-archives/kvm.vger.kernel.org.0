Return-Path: <kvm+bounces-7386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C9CA841327
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 20:19:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E20F1C23F33
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 19:19:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2D4655E75;
	Mon, 29 Jan 2024 19:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MU5Bk1ek";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="t2fG2H4v"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B091335B5;
	Mon, 29 Jan 2024 19:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706555982; cv=fail; b=ApMtt+5YFFyRDxJ2KwY7aghJsOl8e9e5Vd/g8SQtjbLYbWfNhUXRCTDeGlzBbEGUBSznPvShIwVxCpDb0XLpCTZnt2SFRBlmP/2G3nMMS06u67Wm6jOnlk01h45XKVH3INCOBWA96kWF9VqeLZkn+YdPtg2NDdaBRqlzl4DsR2I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706555982; c=relaxed/simple;
	bh=8k1znlmpbPmFlDj4IuGf79ZAoZJaeo4julaQj7dZLOM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ng9z0/vQAVnV4dCLwfyZMkgIcXINzwYZGiHQf2vkkdzpBRNwOiLy5jMjh7QhbmPJHJ1/m2W9rZ21jw6QRhEg25EB0LH0xklW7zxX+3IHJx914xsqur10bSlMqnvuDg0dN4rp/85eVBjaSAdjvNxzPClgN6UB/3H6diYsrSAVj3U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MU5Bk1ek; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=t2fG2H4v; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40TGmqhI028114;
	Mon, 29 Jan 2024 19:18:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=4klArVRSWnxHFFwcWhbh4Z3gWLdUefRdr5NBdSxUaxQ=;
 b=MU5Bk1eke0EAzEo6nYH3+zrHXpM7i/P4j6oNisw2/gPwmh6fcUXqx0S7d0Sb0okxa4jU
 fi1m53s/tK+mm5E/kcOtrt5Wut0DTVmJTSTCZDiRfrAn30AgC5y+O3HElOLuxHP/46Af
 9gIrdi/l2iQnynzBnBi5EnGsZUCCWZhExxPQ2iKy3HGwh5lf09qesULla144UhzgBUba
 6MYpClPQIVdYB1bwSaXVgwMf37GpS5ME4t+CUqRhT/N3sXspVL2QbzeXflKEVN0Uvz4C
 gNLtWDI3YyY8ua6lKue5XPZNksiFXzjMke5nB+SK0zA1aGHqJMO0dy5wKyHeE0lDxZk9 cg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvr8ecqhv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jan 2024 19:18:59 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40TJBhfU014554;
	Mon, 29 Jan 2024 19:18:58 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr962y0w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jan 2024 19:18:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QWHNknDcKwzVMGBlT/VvWZqQleRB6VbQNNhaVvzlA/j6DQ7pMp6PVZ6QZbfWToLaUlB1ldkZSaIAcSzcxF1kx6ewfshSMzyk2tFjWU4PY/f3O1TheH4BbBEdfYftBbblCFFNqj4rLBT4zj+gvszTZVgTVLV0mylis9/THLgMydOUT3laZGdT4MUP+bHbrG1A/htF8gLzvJvX8S3PEPV/UA5RP/LCg/SHes1Tnd3Tmo2MDjwTI00qZtrCx2wi2sBTz+IPQE+diJUuO+kOySNA4s7YuWcfSNpVB6JGnInF+ZdTCk2+OxpqpgYkOqxPmv6W5P+2UMZ7BRdDSWzPtTLXkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4klArVRSWnxHFFwcWhbh4Z3gWLdUefRdr5NBdSxUaxQ=;
 b=m0s8vdHYPnUbHdXWs5gfjRRV6Xr9Q3l45B8/0DwcBcpBIGMS0qdAx31bj+sVj57FGwil9RkCH3i3Hr08VfstpSyHZleReD1Fk5DzvGdjsbsL8CQ8IP9Iek+Lpi01iAnWpXHr/xYKHax12KYmqofxOMVEFIsRKTG0l3UB2nAUBWOASoULea/5oukuESzrbNNg5J8Vz3gSJm0zUtg37K9aIfDMGExWxZNqJHt9mT8clYqHtethj7IM/9BfW6j6MSpFNT06SslO9eSqym3iQyNBv+RICdH92X5dpU4k7lh7DqXmSlxbnV1JuG5sHlnBHMJuFNnp68g+gCZxf+IKSfsXHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4klArVRSWnxHFFwcWhbh4Z3gWLdUefRdr5NBdSxUaxQ=;
 b=t2fG2H4vadPR+dcdl0M42+h/ftwX/4Z4fEO1rHRKJIegl+N7evzmG7Zluee7uxYhOGeS6I54rObXz/Pa1S4jRSD9SKjyGBKoaCEw1E9weDDKraR7zyS0Evbd/3CzWJpt7wMnPNEHDwt3vCjX8+HNZrpU7nlvpNgXm9g5/HLnyGI=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by SJ1PR10MB5906.namprd10.prod.outlook.com (2603:10b6:a03:48b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.31; Mon, 29 Jan
 2024 19:18:54 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::c6e9:8c36:bfbe:9ebf]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::c6e9:8c36:bfbe:9ebf%7]) with mapi id 15.20.7228.029; Mon, 29 Jan 2024
 19:18:54 +0000
From: Liam Merwick <liam.merwick@oracle.com>
To: Michael Roth <michael.roth@amd.com>, "x86@kernel.org" <x86@kernel.org>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com"
	<mingo@redhat.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "hpa@zytor.com"
	<hpa@zytor.com>, "ardb@kernel.org" <ardb@kernel.org>,
        "pbonzini@redhat.com"
	<pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "jmattson@google.com"
	<jmattson@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "slp@redhat.com"
	<slp@redhat.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "srinivas.pandruvada@linux.intel.com" <srinivas.pandruvada@linux.intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "tobin@ibm.com" <tobin@ibm.com>, "bp@alien8.de" <bp@alien8.de>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "ak@linux.intel.com"
	<ak@linux.intel.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com"
	<sathyanarayanan.kuppuswamy@linux.intel.com>,
        "alpergun@google.com"
	<alpergun@google.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
        "nikunj.dadhania@amd.com"
	<nikunj.dadhania@amd.com>,
        "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>,
        Dionna Glaze <dionnaglaze@google.com>,
        Liam Merwick <liam.merwick@oracle.com>
Subject: Re: [PATCH v2 25/25] crypto: ccp: Add the SNP_SET_CONFIG command
Thread-Topic: [PATCH v2 25/25] crypto: ccp: Add the SNP_SET_CONFIG command
Thread-Index: AQHaUBKyZC5KowvA3UScRWyCZr8I57DxLGIA
Date: Mon, 29 Jan 2024 19:18:54 +0000
Message-ID: <57750667-92a2-4510-99fa-af7df8d887fc@oracle.com>
References: <20240126041126.1927228-1-michael.roth@amd.com>
 <20240126041126.1927228-26-michael.roth@amd.com>
In-Reply-To: <20240126041126.1927228-26-michael.roth@amd.com>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-exchange-imapappendstamp: LV8PR10MB7798.namprd10.prod.outlook.com
 (15.20.7202.013)
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5030:EE_|SJ1PR10MB5906:EE_
x-ms-office365-filtering-correlation-id: a8af5ded-9685-438c-1edd-08dc20ff2264
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 Q6hj0UiUGxrUZ5BXfdA/4VHbYw2f4nu9xEsDc67wjl0bs1Vu46WisdPXMK+gCTbgQsHebwgvfno00NkC/07691k65XTrEUthr/B1B3YfN9k1Y0LVnLtVmqaWFeWCIEYHiLbMsHhtW9e8E7CrltjXsH8tcdXP1mFftxQ1vrUz0fZXPepi5Kp7+jhOo8fB8hg4GExDpAEtJ/6Np3mlbzKuPa65Hmj7/O5rSkPmVAzafhCIO/3oVlkRoxM9jXexVvAHFzQmOOqKSuaxnTrISrIcAc4f24Mgek8K5WIqjdcbkAr1JepuHjnfT1NtdfjyvfJLV3VHM5swUWCdtncN9ADGm5nr31xEEBMsNzAZgL+f442KU9B9jRmBCjtM+WH26p9/XSSgxo3Z9mcd137dbp/Qzr7dA9ayvVqbTmqkacDAb5hCH8jDlQvpfhR1eh3DG2+TFreAvbuS0uNNW45eZ9Txh1jPancTJDdrb0LGiA12C6iw4OTDlKsm+haUsgWuzCk2SjEuEH11I+YKocW9ZyfJVnp2uw3KWyqmXkEq7Q4/txtAZ4NXgzulWS4vwFzGSFi44lwYvihfrRF64QulcqjvewrQhWn+TTTXmAvwavGXyyu8c5kjlyJclCGq5HhMHbmyMVcnG0d1O1+OR1TqMegoqKdwpt+1pODdsNaV5a9tZcA=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(346002)(376002)(396003)(39860400002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(31686004)(83380400001)(6512007)(6506007)(53546011)(36756003)(31696002)(86362001)(38070700009)(44832011)(8676002)(8936002)(41300700001)(4326008)(5660300002)(66946007)(122000001)(478600001)(107886003)(38100700002)(316002)(110136005)(66476007)(91956017)(64756008)(76116006)(54906003)(66446008)(66556008)(7406005)(7416002)(6486002)(966005)(2616005)(71200400001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?iso-8859-1?Q?0oFnrxk/7vWSzkqczG/+35oqfU8dFhgWK0lDEdxm1etkgcZSlOCZKq3eSR?=
 =?iso-8859-1?Q?0wT4oW6uETKQLsdPQyVJuTHSKD9w6t3LOw3Ow+ME7t4vnCT6gMjOcmkpq5?=
 =?iso-8859-1?Q?QqW1EACNcbGCTAAlN7r7Hl9n1vM7L7ekfLf8PW+8QBjKdmfi1VvnHiaWz4?=
 =?iso-8859-1?Q?DUxTT1gc45TjSPyf3m72/q1vcQo+0s490pWfeq3h/lbRKno9NvFYe5zpIw?=
 =?iso-8859-1?Q?Wav3jVRCXD4KMP3D5gbJKjCVg3P4ME7T98tS++T2lMN4pOS8RXaabJVKI7?=
 =?iso-8859-1?Q?XB9+yjNrRhZ90wQOdkij2/IXVa1LG7Rv+0CXFL5pnmnLj9+CPtcg9+dxZ2?=
 =?iso-8859-1?Q?M6rOMIZDpoMHamQXbSQ9e/8YbxO0/8NXBcfiSMq7taL0KYJsfAkAA5Isel?=
 =?iso-8859-1?Q?4XMIO6vDh3ZfUnpn/jEbhVcNmmdsAmDJmzxMQ3/6Rwee+HN6zGZIx4bFkd?=
 =?iso-8859-1?Q?GeH3T+JeYhfOvJibdgnQ6xOX+abnqK+JqayXbLXB+51Wimqvi5vQp4qBhR?=
 =?iso-8859-1?Q?lt+jeqzhDTtKDbxl7NFUN18Sj/rp8ibZ5l1ldZOvJSRNlF+NB+3WDEhdE4?=
 =?iso-8859-1?Q?dO7qq/YX05gzhVePB2yr40gyJzMJjIn5qDczmMomCxPmrF/xIgL4tscPfo?=
 =?iso-8859-1?Q?psdptYl4Nmk+8torbdnigHGivZ4T1rmoe3AGxw2m+8nUPlcWesvDVInjbc?=
 =?iso-8859-1?Q?r/j3Z+3PyLPcR34I9iX4p/XTZh41JYFvtgJwuPhj/T08QrER7akeo2zC59?=
 =?iso-8859-1?Q?fW+q8LyOMryfoNOmc9pe1Ppqmi5JQBWSd0G10U0haqDnDEZ20Z80bnNx/9?=
 =?iso-8859-1?Q?IR48ZWOghzhig5k7eKjVUlICS0cMrykycQ0eJxpiWZ+IsiBM61aE3YPm5K?=
 =?iso-8859-1?Q?xm5vhssBDqay7XzuYdHbxTt3D6oHekjPbAwCWph7WiXWJKXEqnCAuQ+f6t?=
 =?iso-8859-1?Q?q29TN5tQgXu1ylO+8AATMRXrABBwU8Hf8bJHVyfco8FTT447uAoGw9D0DZ?=
 =?iso-8859-1?Q?bvVjdJtfWFvg1q9QX84HSk/ekr1sznZBDaWJrYfe8galaK/jOgLBfdArDp?=
 =?iso-8859-1?Q?jLHql+NzTAWy32s074NQhmvQ3dY+clkPH/QpbjdxnsVank7OpmaJxNLRuM?=
 =?iso-8859-1?Q?I0xiLCb3CF7rb5KB/rY3TSooRkaZvglooIbCIa0pt4q1VXiiR41RK/WzkG?=
 =?iso-8859-1?Q?xT0j+x7pTFCL2N0sED/8SBOjmsQU3YgToIuWogm9ppyRajHLYKSgNiRliR?=
 =?iso-8859-1?Q?GPK24DLcLXH5CvxZPoXeoLa3049x0p5qIDomimiWbpCLyhnwR9pG1uYv4X?=
 =?iso-8859-1?Q?jkEEnV//FIC2ogs+D1Ctq12rxQ9uwDm3LYz86HJB9v0qx+GrFWS/Pzgqhw?=
 =?iso-8859-1?Q?HQFgPdQNS3W5N4cP+VrAA24IOlLWa89F4PLwbY0D9ANEBAAmG55Lgq+Y2v?=
 =?iso-8859-1?Q?Vgy8AqO8tUAIZ5Kk52AuyED5wNGNUuN1cvPYAu+taoxX3sZ0YGE3wWfovp?=
 =?iso-8859-1?Q?RsDnFagKhHVeUI85sYCHYM/fvC2JP7IqKk8ivKcpLTtvb0YahPFoi/lCHQ?=
 =?iso-8859-1?Q?m0Ndq+REQXBkRZmgbEw5VoUZaBi6HTSUvjlfps6Jh7gejZ3ENVrFvPbCAH?=
 =?iso-8859-1?Q?ecDL3UjUm7GTgMtD6R/wR5qgwyyEgBZnJuSvjrsFCe6eowf3nqZYWoUw?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <8BEAF16A8035854CA69422599EFAD49C@oracle.onmicrosoft.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	MpuRuevEABQQr0Ot7mHgMq533RSLR3MI1EtkqnbLE918BhCO11CJQRBwlFOE4z7nw2ioG1/oNEeT3RzXisDsd91AbmxImibFYBFDEy5xI9cwcwGrSQEtQq14Qnhu4jtdOgAhSR1Cpgy49J9cUePhPQMb2/lvPNGuGlJKdr/a1DSOyEgOsESQIg42EhqpHXxUbE98yPDyqi2ASqP0n/SF6XAlnbD0qNqtNAm+kMIqUqY/cKiPSm7DkMqUQm6zPQngRS1Yg7WB4xDYtGuWRgsx/AULHNd+Hw2KmJPMZYefFXiYVLT5emUciKnPOSP6qaxbbWygIRqzcG/B03vUcy2H1xRCLxbYFVHKUUK3HFu+6i9XomFNZsRQiwelNCqvw5DMVGFEer+IZOKZeSIfGeXCeGQ6yDrfwhGdJdOFXhmdljX06cUdAMs5bjMQc1dDgHGum9doX7mXOcXLD+2H7a+BDtWN4nuzA/erbbW7VQwvHUB7bfsffoZQdXCyF12abx/Tui2RfWh6L1WwH+RxYvHWvRMPejr7fp4c2V+A45A6IqLV09QlNxrnZ+KGDfRB8/u/0lBXJj/z29gyL3YZLnpJOhOFJFud7UMjWzgITPanR44=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8af5ded-9685-438c-1edd-08dc20ff2264
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2024 19:18:54.5224
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mRfUWjZJvzHfaFhDkohydJ+cGVj9EacAt4iYrgK1FC1s4o/clihn2Cq1G55+QOCyK/O6j0wKMjJhee+xrZ1uPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5906
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-29_12,2024-01-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401290143
X-Proofpoint-ORIG-GUID: yo53NunuBvoou0fr3yny2mkHf_OqIGtM
X-Proofpoint-GUID: yo53NunuBvoou0fr3yny2mkHf_OqIGtM

On 26/01/2024 04:11, Michael Roth wrote:=0A=
> From: Brijesh Singh <brijesh.singh@amd.com>=0A=
> =0A=
> The SEV-SNP firmware provides the SNP_CONFIG command used to set various=
=0A=
> system-wide configuration values for SNP guests, such as the reported=0A=
> TCB version used when signing guest attestation reports. Add an=0A=
> interface to set this via userspace.=0A=
> =0A=
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>=0A=
> Co-developed-by: Alexey Kardashevskiy <aik@amd.com>=0A=
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>=0A=
> Co-developed-by: Dionna Glaze <dionnaglaze@google.com>=0A=
> Signed-off-by: Dionna Glaze <dionnaglaze@google.com>=0A=
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>=0A=
> [mdr: squash in doc patch from Dionna, drop extended request/certificate=
=0A=
>   handling and simplify this to a simple wrapper around SNP_CONFIG fw=0A=
>   cmd]=0A=
> Signed-off-by: Michael Roth <michael.roth@amd.com>=0A=
> ---=0A=
>   Documentation/virt/coco/sev-guest.rst | 13 +++++++++++++=0A=
>   drivers/crypto/ccp/sev-dev.c          | 20 ++++++++++++++++++++=0A=
>   include/uapi/linux/psp-sev.h          |  1 +=0A=
>   3 files changed, 34 insertions(+)=0A=
> =0A=
> diff --git a/Documentation/virt/coco/sev-guest.rst b/Documentation/virt/c=
oco/sev-guest.rst=0A=
> index 007ae828aa2a..14c9de997b7d 100644=0A=
> --- a/Documentation/virt/coco/sev-guest.rst=0A=
> +++ b/Documentation/virt/coco/sev-guest.rst=0A=
> @@ -162,6 +162,19 @@ SEV-SNP firmware SNP_COMMIT command. This prevents r=
oll-back to a previously=0A=
>   committed firmware version. This will also update the reported TCB to m=
atch=0A=
>   that of the currently installed firmware.=0A=
>   =0A=
> +2.6 SNP_SET_CONFIG=0A=
> +------------------=0A=
> +:Technology: sev-snp=0A=
> +:Type: hypervisor ioctl cmd=0A=
> +:Parameters (in): struct sev_user_data_snp_config=0A=
> +:Returns (out): 0 on success, -negative on error=0A=
> +=0A=
> +SNP_SET_CONFIG is used to set the system-wide configuration such as=0A=
> +reported TCB version in the attestation report. The command is similar=
=0A=
> +to SNP_CONFIG command defined in the SEV-SNP spec. The current values of=
=0A=
> +the firmware parameters affected by this command can be queried via=0A=
> +SNP_PLATFORM_STATUS.=0A=
> +=0A=
>   3. SEV-SNP CPUID Enforcement=0A=
>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=0A=
>   =0A=
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c=
=0A=
> index 73ace4064e5a..398ae932aa0b 100644=0A=
> --- a/drivers/crypto/ccp/sev-dev.c=0A=
> +++ b/drivers/crypto/ccp/sev-dev.c=0A=
> @@ -1982,6 +1982,23 @@ static int sev_ioctl_do_snp_commit(struct sev_issu=
e_cmd *argp)=0A=
>   	return __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error);=0A=
>   }=0A=
>   =0A=
> +static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool =
writable)=0A=
> +{=0A=
> +	struct sev_device *sev =3D psp_master->sev_data;=0A=
=0A=
Should this check that psp_master is not NULL? Like the fix for=0A=
https://lore.kernel.org/all/20240125231253.3122579-1-kim.phillips@amd.com/=
=0A=
=0A=
Otherwise,=0A=
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>=0A=
=0A=
> +	struct sev_user_data_snp_config config;=0A=
> +=0A=
> +	if (!sev->snp_initialized || !argp->data)=0A=
> +		return -EINVAL;=0A=
> +=0A=
> +	if (!writable)=0A=
> +		return -EPERM;=0A=
> +=0A=
> +	if (copy_from_user(&config, (void __user *)argp->data, sizeof(config)))=
=0A=
> +		return -EFAULT;=0A=
> +=0A=
> +	return __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);=
=0A=
> +}=0A=
> +=0A=
>   static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned l=
ong arg)=0A=
>   {=0A=
>   	void __user *argp =3D (void __user *)arg;=0A=
> @@ -2039,6 +2056,9 @@ static long sev_ioctl(struct file *file, unsigned i=
nt ioctl, unsigned long arg)=0A=
>   	case SNP_COMMIT:=0A=
>   		ret =3D sev_ioctl_do_snp_commit(&input);=0A=
>   		break;=0A=
> +	case SNP_SET_CONFIG:=0A=
> +		ret =3D sev_ioctl_do_snp_set_config(&input, writable);=0A=
> +		break;=0A=
>   	default:=0A=
>   		ret =3D -EINVAL;=0A=
>   		goto out;=0A=
> diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h=
=0A=
> index 35c207664e95..b7a2c2ee35b7 100644=0A=
> --- a/include/uapi/linux/psp-sev.h=0A=
> +++ b/include/uapi/linux/psp-sev.h=0A=
> @@ -30,6 +30,7 @@ enum {=0A=
>   	SEV_GET_ID2,=0A=
>   	SNP_PLATFORM_STATUS,=0A=
>   	SNP_COMMIT,=0A=
> +	SNP_SET_CONFIG,=0A=
>   =0A=
>   	SEV_MAX,=0A=
>   };=0A=
=0A=

