Return-Path: <kvm+bounces-7381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C44C841195
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 19:04:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB0E51F23D6F
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 18:04:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C677D3F9CD;
	Mon, 29 Jan 2024 18:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G844qknY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="e4dVcBI5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17593F9CE;
	Mon, 29 Jan 2024 18:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706551305; cv=fail; b=SIReF4lUMj4hTuKBFvf0wHTHzdYKLesSL5pspAsMoPAWg7E9RIoDc9+N2+uIXyuCd1B6OFsVbwhCORU0hiVAG85t9PkhMo5dH7Tj4Zl6RmzdDDYR87na60tAvT3sOgNI26v8L0G2/8QK96eARG5ohvsOAog/HRXyd0gWo8X/XGU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706551305; c=relaxed/simple;
	bh=Hjt3LYEHjegOxtyOAWgjtLOEdZzXMbiVThzmbYMnHlw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fKv/fxKkdUawi8zggK8fMHlPfJPU54f9yGAoMWnRubSo/EQx3sOTwpzcRzkaW4Y6U/j4Nfld3C19//t2OxnNhJekoX6PNqgiNxEHeeN0/2DBzUNSj8YGZduEPQgt7+hHNSzBTGP8aDnrQaXKouqZyr8XBq5RM2LoBmkPV/SyoyY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=G844qknY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=e4dVcBI5; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40TGmrlL028135;
	Mon, 29 Jan 2024 18:00:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=C2dhaBGOFz/SXVyv+0kOxPr7iTYjmlQD2Dzg0h0CyDc=;
 b=G844qknYAnL6Zpqs5qC5ce2SHAGu9EM1+RfgrWQ8m5ANorKxooF2tyj+nGfUk4KeMUp4
 ZLec8LspvIv0lgqCa9rAX6AXmJobbXq421xu+tACdd2MH/OfjUm3jWnHZG4XCw4AYYpk
 FElDR7RCmgd9y9LRTVoQOLhh0KtVrYwpuu4mA9RBJFAR01Ao8tdJF8MR70zXMnl6pugv
 BvGXybRJWrBINWh/QuMn2FdYrNTxPUQmOsCSN8SjFDpsvv4Fk03BXBN4rXpUtmRiQ8/t
 tv7d8o9YGt3yERE1CqgZgyoruAJ+tba9xNFu+Yv7bekhHB5hmTdlyMR3Y9GN+3Wr6dpo 9w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvr8ecjd2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jan 2024 18:00:40 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40THvK4u008435;
	Mon, 29 Jan 2024 18:00:39 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9cg6cc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jan 2024 18:00:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G9hCPunUiRafLZplcWMgDeOmQp7LJRS0RM6IjcT633j03q7xbifQPj5REKIdId7lXSDaQbWhHvOs7AUyawzFxyAbPTmKgk6bQbEeQM8elIAjSrDdwUWLBGKeBefX0m95ZkkzAYxePvndXt80CpCcNyitlTHYg5R59OylREn0VicTnWiknbEmbOUS5sftR+uL+DPm6ECVRGmuFGr+p1+45jUKa+shnt0ofI6Uwtl9DbWDuU8d7oup5s3SEDNEYPmrJVjp0xc/yIZN7m/J7h6l1zBEK1R1vbEXB00fdkX3+ihDWKT0HHcpSpUxOSK6edIib886uI2pmNFZRlfmqqK+vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C2dhaBGOFz/SXVyv+0kOxPr7iTYjmlQD2Dzg0h0CyDc=;
 b=TUsJU+7vCTEjMC8YOfIixi0sWajb8I93zCmgDqs/NkDk9G7R9kfCj2CBcX3Cz5FT0lMfCPj+i4DR/ygw7KO+BXI75V8puETdsbxbtpyPjXXFPXvbYkK5yeqYpd7OfkfsSf/ApjqP9ZqRzbFfzKaP2N5kYgI0NejmFi2EWWdatn4Be2TJrn+hlOhESvzNY89x6m9p43uAt8FKjtvEcMEPdT70UWq5bv7GTU4bqsIUQgcEmRe0n+NdDyrHb7WjJPVacUqk9H/E2l6UxINMBXBdN2sNkSickrgkkyTRfmN0Colbm9jfDPpa1ZDRUUDFO8oNF1IHFcfx63vR+DLhPHnDfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C2dhaBGOFz/SXVyv+0kOxPr7iTYjmlQD2Dzg0h0CyDc=;
 b=e4dVcBI5jra/bOzY2cTuS77OzNY7RpKv09kFBXiFf8Dw/rOA2RUSFj4irso5tWnP/rqv3oq+h14yQRLC5tAWizU1vzbmS2K8YKqQ2C3mb0oIzAFpF9besK37VDhBbg9WGyikC/s/U34W/E61w/3pap0qIH2kRal3J/+4IyFluxU=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by DM3PR10MB7928.namprd10.prod.outlook.com (2603:10b6:0:44::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7228.32; Mon, 29 Jan 2024 18:00:36 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::c6e9:8c36:bfbe:9ebf]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::c6e9:8c36:bfbe:9ebf%7]) with mapi id 15.20.7228.029; Mon, 29 Jan 2024
 18:00:36 +0000
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
        Liam Merwick <liam.merwick@oracle.com>
Subject: Re: [PATCH v2 10/25] x86/sev: Add helper functions for RMPUPDATE and
 PSMASH instruction
Thread-Topic: [PATCH v2 10/25] x86/sev: Add helper functions for RMPUPDATE and
 PSMASH instruction
Thread-Index: AQHaUBHag0GCwZsLtkOjW0igYQCdjLDxGcyA
Date: Mon, 29 Jan 2024 18:00:36 +0000
Message-ID: <23cb85b1-4072-45a4-b7dd-9afd6ad20126@oracle.com>
References: <20240126041126.1927228-1-michael.roth@amd.com>
 <20240126041126.1927228-11-michael.roth@amd.com>
In-Reply-To: <20240126041126.1927228-11-michael.roth@amd.com>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-exchange-imapappendstamp: BN0PR10MB5206.namprd10.prod.outlook.com
 (15.20.7202.013)
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5030:EE_|DM3PR10MB7928:EE_
x-ms-office365-filtering-correlation-id: 66731092-163a-4fdb-5c6e-08dc20f431ef
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 Q+/mFxoc9OB8dAY+0j0OyWEMDN5YqFrE8Ec8rmY93cOb7O9SIWUqbttik44+99EkagplTUOlizNnobKp6Hwe7Iz78h9yYCxML64mmsS0xonn97CGN3aWxswggHITCSqpyC4tlPgcSs953nsX3U6XtMBG58A1eUKPd1a+LNOiqBVf822OQfjY/4tKH4e0r7a0Bt15t+b4Bs2XZK2I/lJcrF44FKuZAKjlWEwnfakL3DWF4aTxDZPApXLP3VKijVRbV3oJsYHNOrV1CsrIEd0Kslwmc3Qp2+/SgLj7zy72buQVck4jgXooCFDBCLBBmF2SJeQFPuhhKrifJfmsZsqoPbxEBEKnRMF+yXztxTID4ZxaGQfclAIMvQuFuK/wTx37eSV6WQZXxdjLxC1Rg09OYNuRBStxFVP42FOL4foYqUrNzalGX6mMwP0PWS+UuoD5dty/WtcK7auP9t7bmq5zl4aVrrSA1cFLca57j/6fx+J9LN++IRSxNrgNi1kjK2Qtw94l5ae9+4EEnrT1QGIQV47leXTtDM73qEJW7uiU4UCtPdSF1uAHZ8ln7wPg2T91OOMAR2RcP6G6K3UtE07vkGywH/gO01QxLEva2ZyI7IL9nB+BiBoBBHaGM+uuJu9OobXk6X08WFoJJ7PFsZ9CV7gSVxaG7qSNsczPtqhljWwBjQy4YfLT4nr+aoVB1QBb
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(39860400002)(346002)(376002)(366004)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(31686004)(83380400001)(31696002)(86362001)(36756003)(38070700009)(122000001)(38100700002)(107886003)(2616005)(7416002)(6512007)(66556008)(66446008)(53546011)(6506007)(2906002)(6486002)(8676002)(478600001)(7406005)(110136005)(76116006)(316002)(71200400001)(64756008)(66946007)(54906003)(41300700001)(66476007)(91956017)(4326008)(8936002)(5660300002)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?iso-8859-1?Q?nJE/dU5LGl7lMhfqoFvhB/DBhbWwUm03XW+YIcbn2XWJsvcrJzbReS0Z2c?=
 =?iso-8859-1?Q?M4yQY7B8aVkycs2DvBiQo4vMaqIlmOuLCB6YT0qtYIF2m0+8szmm57hAZq?=
 =?iso-8859-1?Q?AASt6PpbWjP9IZY4yoLDJeHnqCkaQZH+mWC9OKpafPBbrW/BkejS5LytFK?=
 =?iso-8859-1?Q?jV98IKfwykEIdVvB7L8XNom6G+O9EemlKHHV7w1fm0F4Ud/QlPpErnA1wl?=
 =?iso-8859-1?Q?UOJxgQuUPRDqFU1ykkgkWwI3AsWuEqCXHZzMxI7eKYSEAdw+HBfQVyCX/z?=
 =?iso-8859-1?Q?fLjHPidpd87GvjXpgcrXYiEqITLaBOiB3EpnZVgDXmyCreQn7HEOvGdPPb?=
 =?iso-8859-1?Q?7lyfgBTlgkQ8RsrPCUlDEXW7vJsTAV/kFkJNDQVkXDmc4XDoFwpuhREWbu?=
 =?iso-8859-1?Q?4Ux9BCdeJ+/fZ8LyfupErPSjU5mocR5vozAB8f+ATF3UTDQ3gZJNVSx+A0?=
 =?iso-8859-1?Q?0Qaa6AiXcRcK6BOQKaZELgLh03Zzku2OT96ThmES8Tlv/XJAjVhpibFsv8?=
 =?iso-8859-1?Q?cbYku3rqRivXIHEFNoLibBozzgPf+uMoyjsOIlv/MrknNFoJLNvykII3Te?=
 =?iso-8859-1?Q?YXb4FJF39QEt3WEhtDGnV8/4hxNQcbviB20AvKmoirSU7M5h4IVgKnaxV0?=
 =?iso-8859-1?Q?DeJRMPO+EXISBppCWRxHg0xE3/8XJ9Ig/uQamae70kIN7sB7Vk3Hmv93KN?=
 =?iso-8859-1?Q?XuTyOlHlx1+n06wr5mXyBbYMZ5PUzdKkRueU3S1o3BFvCIXLKACJusIw1v?=
 =?iso-8859-1?Q?YaZkBZfBni1E5tknTYFY1A8pC5u5odmaPJnQ6k6omBm+58/YsQEjEtkY0g?=
 =?iso-8859-1?Q?oxNZHfvPP4OgIcb0LOA/TK79UwlcHwaULMZcl20u8/rPt7wzCb+R22SbVE?=
 =?iso-8859-1?Q?4Es22GiIX39da2vUoL4I+Fv7tJatLHkW26RD3EC/paSmVTcMXzBBBUq+z8?=
 =?iso-8859-1?Q?eGxp+2KqEcaxBkYu1UtY7+zmcq2iiSD0ieSsMkoSu4bXJFqQxjJXf0KzBu?=
 =?iso-8859-1?Q?oKdMv+h6yRpdOEF/nC4aVMZ8Ni9rf/Luw62KX9QNST5wJOeGBfWhT/aQ4T?=
 =?iso-8859-1?Q?bNfa4qRbW4xamP1+eQP/l7ki8Sm76Q6vYAGXp1ImbBEz6j7MxBHxqHsQ9o?=
 =?iso-8859-1?Q?x3Ok7nPC5mo5/RkgyefTVID5GnQD0hOc+fuDuIz7UmsDvrmVex4SRgqWEJ?=
 =?iso-8859-1?Q?YMj9ThSeB4Wtj8+q6QdiXGQmxEha7ZVEr59t6T+gr3MV/wLC9Yc6nf+lBh?=
 =?iso-8859-1?Q?t06lNhKxxVBAVgqlonvpUiXtBg1Ict0u/2ex+yHo1hF73TGKgB74mD20Do?=
 =?iso-8859-1?Q?SJclqGsvehOkyLy6HBDek9aVSbVx/QtwGAxGkC+pMjZaRg/tK5J80nQzr2?=
 =?iso-8859-1?Q?O7mGUkpA9kUjswzVPh5Y9gnAPzDOSjGzwWOw0iREPz4ozr+41QYsjo7Rqn?=
 =?iso-8859-1?Q?QCKkg15aXX3rZveYMCpkyU79WAL4cdsO3fU6bpVZ40YJEQfC2BVm/mhtdk?=
 =?iso-8859-1?Q?5Q7Uj0CIahRoWhAHJlgHKNwMAxYf1WPD1O2sbaaTtBOCNGapiOjGcoXRnv?=
 =?iso-8859-1?Q?NEYbT/43Gt3XY4BxWK21DgNiQEn6g0jn7WESSBBbfp3VTNK+SVFWqX4tw8?=
 =?iso-8859-1?Q?vXxCEkyXuPgSbC5Y/hichcKio+hwZZDavcjKE1zdi/URFXuC52Mg65zw?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <A3BFF8B56B5AFF43B6FCA971C138018B@oracle.onmicrosoft.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	5QNIivDAka8EhwJyuXIMW6YYgh0fabQx3nzCNoTPKj0brFIR6nA4V7hOnfq8g6YY9hmiRPhZuZvDmNi9yQ3QyylCAVioNWFZY0XOkfU9SiTjDRmWyDcMt+YVSMp7RsEqM9BYnFD9f37kszZFeC2Flte8izYsTIRDaejUAByNQ1Bn8RTuISA37WaHOSLWtv+Tw0LJLTdCBeC0cxQqy9mj957oXir8rFnA0/gnxnhLr7dZUZ06qnBbN8aFvuD0prAyUfDikMWhUyNnKGWRbBREHF45fi4XSTkCtVaE04Xhen+6qnYS/Mk5asTTgLk5bEIvzJmDGY2+/YR1evzYn53ib6EhgNrfNxyk0RIpjrws6TJTU/m6EWHkMMoXZMUA5/MX7VR9YD5KnVQes+ueVUe7sNJy9cGy7SoMBg0qNKja8ppuPqmyaQ3nhhLYH2/e0+qRbkubKfvlkXpwM9oeMCxnpaP49BDy/xpHGFvSMa81iMKpeeWJEgk8xAId12K41WtlQAFCVmHBiug2jmOCZTmSylomgeVVsuUoMOVLoY0eeNQthbmrDHg+V1nPG3oKCZ6tsjt95vAGCs70/G2vTRJeGBjyULKDueDwTJX5QbJZFdg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66731092-163a-4fdb-5c6e-08dc20f431ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2024 18:00:36.1286
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +74p6EolD3o7d2n836g6d3CyzbEqdSRoShuKa9LwxHA+bNCL5gsgu0dnxsDKuKVFO/YFzdmE057kYA47CfWoTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR10MB7928
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-29_11,2024-01-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401290133
X-Proofpoint-ORIG-GUID: wDS-nM4k0bNnF65DXhlMWMkvBbaJxYB7
X-Proofpoint-GUID: wDS-nM4k0bNnF65DXhlMWMkvBbaJxYB7

On 26/01/2024 04:11, Michael Roth wrote:=0A=
> From: Brijesh Singh <brijesh.singh@amd.com>=0A=
> =0A=
> The RMPUPDATE instruction updates the access restrictions for a page via=
=0A=
> its corresponding entry in the RMP Table. The hypervisor will use the=0A=
> instruction to enforce various access restrictions on pages used for=0A=
> confidential guests and other specialized functionality. See APM3 for=0A=
> details on the instruction operations.=0A=
> =0A=
> The PSMASH instruction expands a 2MB RMP entry in the RMP table into a=0A=
> corresponding set of contiguous 4KB RMP entries while retaining the=0A=
> state of the validated bit from the original 2MB RMP entry. The=0A=
> hypervisor will use this instruction in cases where it needs to re-map a=
=0A=
> page as 4K rather than 2MB in a guest's nested page table.=0A=
> =0A=
> Add helpers to make use of these instructions.=0A=
> =0A=
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>=0A=
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>=0A=
> [mdr: add RMPUPDATE retry logic for transient FAIL_OVERLAP errors]=0A=
> Signed-off-by: Michael Roth <michael.roth@amd.com>=0A=
> ---=0A=
>   arch/x86/include/asm/sev.h | 23 ++++++++++=0A=
>   arch/x86/virt/svm/sev.c    | 92 ++++++++++++++++++++++++++++++++++++++=
=0A=
>   2 files changed, 115 insertions(+)=0A=
> =0A=
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h=0A=
> index 2c53e3de0b71..d3ccb7a0c7e9 100644=0A=
> --- a/arch/x86/include/asm/sev.h=0A=
> +++ b/arch/x86/include/asm/sev.h=0A=
> @@ -87,10 +87,23 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs)=
;=0A=
>   /* Software defined (when rFlags.CF =3D 1) */=0A=
>   #define PVALIDATE_FAIL_NOUPDATE		255=0A=
>   =0A=
> +/* RMUPDATE detected 4K page and 2MB page overlap. */=0A=
> +#define RMPUPDATE_FAIL_OVERLAP		4=0A=
> +=0A=
>   /* RMP page size */=0A=
>   #define RMP_PG_SIZE_4K			0=0A=
>   #define RMP_PG_SIZE_2M			1=0A=
>   #define RMP_TO_PG_LEVEL(level)		(((level) =3D=3D RMP_PG_SIZE_4K) ? PG_L=
EVEL_4K : PG_LEVEL_2M)=0A=
> +#define PG_LEVEL_TO_RMP(level)		(((level) =3D=3D PG_LEVEL_4K) ? RMP_PG_S=
IZE_4K : RMP_PG_SIZE_2M)=0A=
> +=0A=
> +struct rmp_state {=0A=
> +	u64 gpa;=0A=
> +	u8 assigned;=0A=
> +	u8 pagesize;=0A=
> +	u8 immutable;=0A=
> +	u8 rsvd;=0A=
> +	u32 asid;=0A=
> +} __packed;=0A=
>   =0A=
>   #define RMPADJUST_VMSA_PAGE_BIT		BIT(16)=0A=
>   =0A=
> @@ -248,10 +261,20 @@ static inline u64 sev_get_status(void) { return 0; =
}=0A=
>   bool snp_probe_rmptable_info(void);=0A=
>   int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level);=0A=
>   void snp_dump_hva_rmpentry(unsigned long address);=0A=
> +int psmash(u64 pfn);=0A=
> +int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bo=
ol immutable);=0A=
> +int rmp_make_shared(u64 pfn, enum pg_level level);=0A=
>   #else=0A=
>   static inline bool snp_probe_rmptable_info(void) { return false; }=0A=
>   static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *lev=
el) { return -ENODEV; }=0A=
>   static inline void snp_dump_hva_rmpentry(unsigned long address) {}=0A=
> +static inline int psmash(u64 pfn) { return -ENODEV; }=0A=
> +static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level=
, int asid,=0A=
> +				   bool immutable)=0A=
> +{=0A=
> +	return -ENODEV;=0A=
> +}=0A=
> +static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return=
 -ENODEV; }=0A=
>   #endif=0A=
>   =0A=
>   #endif=0A=
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c=0A=
> index c74266e039b2..16b3d8139649 100644=0A=
> --- a/arch/x86/virt/svm/sev.c=0A=
> +++ b/arch/x86/virt/svm/sev.c=0A=
> @@ -342,3 +342,95 @@ void snp_dump_hva_rmpentry(unsigned long hva)=0A=
>   	paddr =3D PFN_PHYS(pte_pfn(*pte)) | (hva & ~page_level_mask(level));=
=0A=
>   	dump_rmpentry(PHYS_PFN(paddr));=0A=
>   }=0A=
> +=0A=
> +/*=0A=
> + * PSMASH a 2MB aligned page into 4K pages in the RMP table while preser=
ving the=0A=
> + * Validated bit.=0A=
> + */=0A=
> +int psmash(u64 pfn)=0A=
> +{=0A=
> +	unsigned long paddr =3D pfn << PAGE_SHIFT;=0A=
> +	int ret;=0A=
> +=0A=
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))=0A=
> +		return -ENODEV;=0A=
> +=0A=
> +	if (!pfn_valid(pfn))=0A=
> +		return -EINVAL;=0A=
> +=0A=
> +	/* Binutils version 2.36 supports the PSMASH mnemonic. */=0A=
> +	asm volatile(".byte 0xF3, 0x0F, 0x01, 0xFF"=0A=
> +		      : "=3Da" (ret)=0A=
> +		      : "a" (paddr)=0A=
> +		      : "memory", "cc");=0A=
> +=0A=
> +	return ret;=0A=
> +}=0A=
> +EXPORT_SYMBOL_GPL(psmash);=0A=
> +=0A=
> +/*=0A=
> + * It is expected that those operations are seldom enough so that no mut=
ual=0A=
> + * exclusion of updaters is needed and thus the overlap error condition =
below=0A=
> + * should happen very seldomly and would get resolved relatively quickly=
 by=0A=
> + * the firmware.=0A=
> + *=0A=
> + * If not, one could consider introducing a mutex or so here to sync con=
current=0A=
> + * RMP updates and thus diminish the amount of cases where firmware need=
s to=0A=
> + * lock 2M ranges to protect against concurrent updates.=0A=
> + *=0A=
> + * The optimal solution would be range locking to avoid locking disjoint=
=0A=
> + * regions unnecessarily but there's no support for that yet.=0A=
> + */=0A=
> +static int rmpupdate(u64 pfn, struct rmp_state *state)=0A=
> +{=0A=
> +	unsigned long paddr =3D pfn << PAGE_SHIFT;=0A=
> +	int ret;=0A=
> +=0A=
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))=0A=
> +		return -ENODEV;=0A=
> +=0A=
> +	do {=0A=
> +		/* Binutils version 2.36 supports the RMPUPDATE mnemonic. */=0A=
> +		asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"=0A=
> +			     : "=3Da" (ret)=0A=
> +			     : "a" (paddr), "c" ((unsigned long)state)=0A=
> +			     : "memory", "cc");=0A=
> +	} while (ret =3D=3D RMPUPDATE_FAIL_OVERLAP);=0A=
> +=0A=
> +	if (ret) {=0A=
> +		pr_err("RMPUPDATE failed for PFN %llx, ret: %d\n", pfn, ret);=0A=
> +		dump_rmpentry(pfn);=0A=
> +		dump_stack();=0A=
> +		return -EFAULT;=0A=
> +	}=0A=
> +=0A=
> +	return 0;=0A=
> +}=0A=
> +=0A=
> +/* Transition a page to guest-owned/private state in the RMP table. */=
=0A=
> +int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bo=
ol immutable)=0A=
=0A=
=0A=
asid is typically a u32 (or at least unsigned) - is it better to avoid =0A=
potential conversion issues with an 'int'?=0A=
=0A=
Otherwise=0A=
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>=0A=
=0A=
=0A=
> +{=0A=
> +	struct rmp_state state;=0A=
> +=0A=
> +	memset(&state, 0, sizeof(state));=0A=
> +	state.assigned =3D 1;=0A=
> +	state.asid =3D asid > +	state.immutable =3D immutable;=0A=
> +	state.gpa =3D gpa;=0A=
> +	state.pagesize =3D PG_LEVEL_TO_RMP(level);=0A=
> +=0A=
> +	return rmpupdate(pfn, &state);=0A=
> +}=0A=
> +EXPORT_SYMBOL_GPL(rmp_make_private);=0A=
> +=0A=
> +/* Transition a page to hypervisor-owned/shared state in the RMP table. =
*/=0A=
> +int rmp_make_shared(u64 pfn, enum pg_level level)=0A=
> +{=0A=
> +	struct rmp_state state;=0A=
> +=0A=
> +	memset(&state, 0, sizeof(state));=0A=
> +	state.pagesize =3D PG_LEVEL_TO_RMP(level);=0A=
> +=0A=
> +	return rmpupdate(pfn, &state);=0A=
> +}=0A=
> +EXPORT_SYMBOL_GPL(rmp_make_shared);=0A=
=0A=

