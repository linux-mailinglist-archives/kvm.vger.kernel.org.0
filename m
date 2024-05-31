Return-Path: <kvm+bounces-18538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01E368D65A2
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 17:21:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4AE4BB25BED
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 15:20:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF36876405;
	Fri, 31 May 2024 15:20:08 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841A8770EA
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 15:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717168808; cv=fail; b=A6lGYoaXnZ0zbolkmwzBhDCFawH0Sn1KUiMndkY1IcTizNYYyk9Dy94I0qU3hbtaKR5vdK5lQ9aFVzJ+9YV6NS2ui4cu40wBp7YTB2Wz6l136gty7kTUiG0HUaeCsgo6i9futkyFIYP5YvgI/mvhdZC2RUUY4zaKmATBv8KzC8w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717168808; c=relaxed/simple;
	bh=Z9MNMi/SSQPigMTiNTLppQISHXAYC2q00c1wWAA0Fpg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=g9no/uciNnxGuSD43EXhJ3JmJ24/nT+hT+W+2pinW6hjmGUU5VNDTAK4hekW/cq0NjydyEEhLXxgFsLBxBDV6OMHOMRXhSgFoOm82aIEUvN3z7xCxvh65b4Fm6uYWmjXsIEikE48VeBw3YHHYCzUMNqazzzA1nmqREG1dnyWxC0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44V9VfKM025637;
	Fri, 31 May 2024 15:19:46 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-id:content-transfer-encoding:content-type:date:fr?=
 =?UTF-8?Q?om:in-reply-to:message-id:mime-version:references:subject:to;_s?=
 =?UTF-8?Q?=3Dcorp-2023-11-20;_bh=3DT4Go6bsLnyZgu4CYCyX9QJ+B1XZ3iZ9iZqY+m/?=
 =?UTF-8?Q?phFpI=3D;_b=3DiJcGmJ6j4Cs2X+b02eaTArqrWDu0mzkZYL2yPiGSVi95sHG7O?=
 =?UTF-8?Q?JpDLZ9mthqQlDaQ31w1_hpXinh7csEnkgcCUbFTwAYBcdTi4MPcmdx1H45QgSQF?=
 =?UTF-8?Q?kNP409FrDphvAta7bkUbI2ZeU_rCfDb+77PUr7cOHzeGPB1VkL1L0vKKG0IH1YI?=
 =?UTF-8?Q?C+ejZaeVDinnpUAo9cdQ0oyNa78MATb_s37k3aBsnu6KIirMM+cN3AqGM8oP3kN?=
 =?UTF-8?Q?Ok5fLxUrTn/8K8DwGD0tn80/yKKnCCH2Lsr/O_AAI0HlhVa3Kq+l2MojH/Uxaj1?=
 =?UTF-8?Q?E+sfFFGid5yGVja45LjfT2pDfKMee0ZQls2hbji+p5Z_HA=3D=3D_?=
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yb8p7uar2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 May 2024 15:19:46 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44VEDvfx026532;
	Fri, 31 May 2024 15:19:45 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3yc50a0f0h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 May 2024 15:19:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eQlegXK07RhK3+Pbqtefmpp4BDcbDsaWyajGBJzSwBkxts7uI6w3WJU/0q0CBrfRvzCeXszuLJtTPx3wpB7WVr5evKX9TT6QVjDpt9ENLXg+qOm8N8d8jEV7+GoMeglWnn3JwH9ezaJoWS+RlbGs5fjEf9fY0r/FxUjrBaW2uTxk8fOWXc54zNQ8ANQOCV0o2GhTJFK9tLmAbb52vIdUYLew6PAJGEhVipKIHs78jZjgTcuG1bWyvLxESKISVA/eH4RpJHsgMW4kcLTUYGCFZVaznUpKsQ3pzlg2bKBox+wzyrBntYNEak7AcZE/BTc5vigycKYD0dPw3833UPSU6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T4Go6bsLnyZgu4CYCyX9QJ+B1XZ3iZ9iZqY+m/phFpI=;
 b=Hb/x1JqgKkzr70vh6W7jbJFYO2hFZMscwGGQvy3ugBXrU2Lz3AmIUlDpx+31rO1RVgw2pG1CJTaVrrLP9bRW8InqQdfJ3cWw53W/JuUZcPeR3szfDeKTaZF+ClI3nBOSR5DiSjHHYETbsXy4uYBhrv0ExpjYxc5e2h0aBfBTvymdUTgHwVyLe5fZ6k/FkstsXiFFJS3WVf218gJZD2hZQK3sU2vsddbc7fd1FCi3LnK13vBaVDhar7xOwqs5OM1EJJmADOvTWcg0wcYTijkYkJWag2iq+zs56ocRnxAfQnaDKbciggM1jmwHB2GvPPYz4OBYFMlakoPISHvEIMXeDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T4Go6bsLnyZgu4CYCyX9QJ+B1XZ3iZ9iZqY+m/phFpI=;
 b=byIyHealVmRitYom37NIceX196LH8Qai+x+pt8Er5e4/mdIqho1r28/GlhZr9rCGpwC6YyuHudgkvQRBkgC76C6/YoHLsjy7riy8EZgkj8diLB6Ko+vvZvbumF8HFVDJRd00FoSvd5VCMrad2oc8XEoSrfku4e7po6nXNVJVcfk=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by CH3PR10MB6786.namprd10.prod.outlook.com (2603:10b6:610:140::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22; Fri, 31 May
 2024 15:19:41 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237%4]) with mapi id 15.20.7633.018; Fri, 31 May 2024
 15:19:39 +0000
From: Liam Merwick <liam.merwick@oracle.com>
To: Pankaj Gupta <pankaj.gupta@amd.com>,
        "qemu-devel@nongnu.org"
	<qemu-devel@nongnu.org>
CC: "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "dovmurik@linux.ibm.com"
	<dovmurik@linux.ibm.com>,
        "armbru@redhat.com" <armbru@redhat.com>,
        "michael.roth@amd.com" <michael.roth@amd.com>,
        "xiaoyao.li@intel.com"
	<xiaoyao.li@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "isaku.yamahata@intel.com" <isaku.yamahata@intel.com>,
        "berrange@redhat.com"
	<berrange@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "anisinha@redhat.com" <anisinha@redhat.com>,
        Liam Merwick
	<liam.merwick@oracle.com>
Subject: Re: [PATCH v4 18/31] hw/i386/sev: Add function to get SEV metadata
 from OVMF header
Thread-Topic: [PATCH v4 18/31] hw/i386/sev: Add function to get SEV metadata
 from OVMF header
Thread-Index: AQHasoMyQ2Ldv26sZE+HkIhGzAbDT7GxhxiA
Date: Fri, 31 May 2024 15:19:39 +0000
Message-ID: <792b99d5-9d18-42f4-a9f4-5621e2ae6a70@oracle.com>
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
 <20240530111643.1091816-19-pankaj.gupta@amd.com>
In-Reply-To: <20240530111643.1091816-19-pankaj.gupta@amd.com>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-exchange-imapappendstamp: BN0PR10MB5030.namprd10.prod.outlook.com
 (15.20.7633.017)
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5030:EE_|CH3PR10MB6786:EE_
x-ms-office365-filtering-correlation-id: 3b86c848-0084-4b85-245e-08dc81851710
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: 
 BCL:0;ARA:13230031|1800799015|7416005|376005|366007|38070700009;
x-microsoft-antispam-message-info: 
 =?iso-8859-1?Q?PP3v3mqwyqwemlgpX9nVowAQHlR0IInZg5dz3WPzvP23P9s2SqaNkdEfFh?=
 =?iso-8859-1?Q?roQ347VTRUnf90SGUoUojon5CQCHK4pyIdcMZizux7mNDjtT6jgvo1EKn/?=
 =?iso-8859-1?Q?Ey9FXRvFAmwBP28F1barKYsrCbcaVKQbwTG210/rQo5zb1oUbBW/Kqm/ab?=
 =?iso-8859-1?Q?PEV07vOaaIt+8A9jVz8SbaifSphjzRPpykmcaK5GklZ8C9wMKOiJwFUigk?=
 =?iso-8859-1?Q?FXf3Hf3P5I3zq3h8Aemuih/b0rWW8hunnl3KGmW7FbBMYoD5kcm0FZWS+C?=
 =?iso-8859-1?Q?HZ3ke452W31rXrit6viob1f4pWBKw/Vt1ak5/mgypQTeKvQjOBomxWOx5H?=
 =?iso-8859-1?Q?0aTkxYSWHEOkSVg5OCzhcz7DJrEMwK8UmDWiLyDXj/kEzy+hN8g61gnuhu?=
 =?iso-8859-1?Q?f4Z1RwnFD/jCEXacmGlL9oYnAlRR9uLPdkwHwI7Pp7BAlOYSd4R7mIyLvG?=
 =?iso-8859-1?Q?X6I2vErvr1s/nrB3Gsl0pf7K5lkqevnmVbZ43Mzt5FjV8QRLr+/ShZ2CDJ?=
 =?iso-8859-1?Q?POaqVHYW3rgoZ3OW5q9bGQP7fHzpp1FMRKmgIBYcSypKZpEQgyyhfG88IE?=
 =?iso-8859-1?Q?tWyu+iC3p/AkKAP8ooGvtER5XwMs2XtJTQznza1SnPL55algGpTSdkNyCN?=
 =?iso-8859-1?Q?t/dohCv/c3YIJ+EMK+cZ+NrmsFwLXykFDRuhPehvMVLj4DM97+TwoDaS20?=
 =?iso-8859-1?Q?IHJm72NuD3Lu3wHWufzvupXsD5quW9SOsY81ONHYrR3yw+F+7Ie7RsBsJD?=
 =?iso-8859-1?Q?foyjUNYdta4aXj5763MayLdnB0ghyFFFpBwuKW+P+xYt+YbOPsSde2lfF9?=
 =?iso-8859-1?Q?eVKTOnJHABPoYTdTbiztmbhIejUllwasL7BOOJvxJgRe59SjI0v1sWO5ZZ?=
 =?iso-8859-1?Q?sy4f1QbAoGwN9RTsnPtKydYl3h3+0V4pzgoTEZzFNctMb4XS+rywIW1MgB?=
 =?iso-8859-1?Q?JRBBAf34AUxJzqA+8V6cmh8e7zYS9iSfbWc7PhuKUk59zSLwT/uG22VfjZ?=
 =?iso-8859-1?Q?W6qSh4Hic20ZEcaBV1UMEXli3FCQW8/urqzVZ5FFpq1Gpd05R1VmNMXdcP?=
 =?iso-8859-1?Q?41D6eXHvDTVGqyNm6HwIoE4Ls0584FmlndghhjPyjb9Zv4RZzMT/NXk6ww?=
 =?iso-8859-1?Q?Yw6p1q0MEnTFtUg3ijMEqz1igm1rv8kmOyn/EDBjAUsRXFnJBHUYpm99JM?=
 =?iso-8859-1?Q?IX19w+m/P0Cjk+zE/dpV08QUHEjoq9Qr7JkzMQ+C9RDliPw1eoH79g0IM/?=
 =?iso-8859-1?Q?8u3ZUQIiclF4C4VWyDe+NEJsG/Wk8h7CPg1yxGXjAkZgyIYAz38VDMYdf/?=
 =?iso-8859-1?Q?3tNLQabcIAgtpQKQCkHhLJ9s2EeqfvWjqYWBW5tJ438GuKK2gZwhwy+1Is?=
 =?iso-8859-1?Q?cRWlFzSVQFCh20zcyIA+1fZ3BUP/Kt3w=3D=3D?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?iso-8859-1?Q?Yoxr+2mvCzAifjR3mf0QPrFi4jtjNrOfpogltc1BS8h1zdl4mlRn3y2VQv?=
 =?iso-8859-1?Q?EPKoTiyAiPfV08mneCQpqP4dQawfNEefuWg+eEAZX1Fcdfr7sPSYPkEU5N?=
 =?iso-8859-1?Q?iJUDyAGdjV/miOkmYIxp4fznR/YpF5HMS//j9+xpA8S/ipEeT8NuF70fiA?=
 =?iso-8859-1?Q?elVBHk+KOxFohcm8Xo0xWFAIA+VMgmEJKdJfPFf2u0yT5NnTO97nWvRY9L?=
 =?iso-8859-1?Q?oJ3eeptTC4l76E+6n8yM4yYutuIkFRX8ZR0hxKay3xYaSMEIqX6wESUYGn?=
 =?iso-8859-1?Q?QVJuNgXFaks//+mQ/RKEml9Sup+t9+R5N0TZ5etDRwMMmSYOgEajeKKhmG?=
 =?iso-8859-1?Q?72TJE6eAFeuY22lYRWN5+2hZ+rXaPwqB88QzZ1/U9YvtqglNtDrqPvvGNk?=
 =?iso-8859-1?Q?nyu5tFOEpScgsheMiNQeh4bxn3RXodCS/4jaHPMLkLTfVFq7sNgSvV2UOt?=
 =?iso-8859-1?Q?iyNzSfg97ljMrSMiv2mTHGtXL1jnC05aa3NP+63/yTDr3Ahnmr12H70Mvf?=
 =?iso-8859-1?Q?gJQPqAR+iCs0+j/CJdsNdrGMbO/6afzN53kZryE6u7T4eSQNjtusBikZtb?=
 =?iso-8859-1?Q?DlaSkYy3sSDT9uIAB80qVYautcsP4piWy2ixPzto3JaN5LdDRML/2BAPKB?=
 =?iso-8859-1?Q?5pXswrS7lJQN1biXmMVvsoOaZIK7TovX3A1KV7tQ45q4Kz8Vi2vJkcEFES?=
 =?iso-8859-1?Q?7c9t1N9IEEIpAEXGnMLrH+pgKnoGExG8z7ond/s++wgtaHUS9XyVar1VMn?=
 =?iso-8859-1?Q?NbK1poX60sJjWyWMt6RmJmGJEr4MN1puk3At3zrj/S7s4TVAaCGJ2U+ycS?=
 =?iso-8859-1?Q?wE1daftoPz6/jiaZnReUyuf6dWUsG8aC0+Yi7GTRqd1lvxbtIHWlT/vynT?=
 =?iso-8859-1?Q?30/KpGfUdVSo04u2HnR0TLPTeFUjiS/ivYcSGtBD0VV1Krjyz5u0if5/yF?=
 =?iso-8859-1?Q?o376EO9YzcEvusdEhlHlAGFVlNDj9D9QIAM+yyQkr2QHIfQByZPKTC3IV7?=
 =?iso-8859-1?Q?DYOHTieN6LZpVfcR/zz9JgblY08SCJbA47DoEgnP7vPFW8OGmWBRCxQtFV?=
 =?iso-8859-1?Q?Cz310PAeSlOQT4dDRqdqkLqwHqn7cyOnf1KTNzhchLPT6245Qxnuvt1ZnJ?=
 =?iso-8859-1?Q?V3RmSfxJGtMnOlaa2YYX7TQDRzCaMiTiLJEfKwIGxGAFKyESL+Mx//ABeZ?=
 =?iso-8859-1?Q?PdQaPgrwAtb7YqIcxjL4bVv2lj9ImOr35vN8LbNe+x4LbzH5PkEFVjvL18?=
 =?iso-8859-1?Q?3RM8qi4tjWg0JqE2xN4abhN8whLDZrMuo05L7i/3FCe3oZrUYt/8zsUCMp?=
 =?iso-8859-1?Q?EWDtGERT1MBGtoA0ztzoAD2aF3Q6z/9m+ICmjzwOZYDxP1H6XNeWXvH/o8?=
 =?iso-8859-1?Q?Hwvwml1b24XWrHUy0VSPbppMNW0dr0JWpf0pbChGM38HQyTHB86j4MdhI9?=
 =?iso-8859-1?Q?xLujnLEVGqLMUX+A72We2zZXMyzkpFYY//yjk/ilst9MTz54WVOE9+uwh2?=
 =?iso-8859-1?Q?xQh2qp4lbV1UOq3HCxTo8x6Wm30UZv8vEg18RhPJNzFH2jXQP0i+7fYvEI?=
 =?iso-8859-1?Q?qY9Heu0RGH92JvyhcpCwO+9ippktLj7bpb7UXFWbT+QMC5R2Y/NpF0T5gs?=
 =?iso-8859-1?Q?i5dk8/csGFEY7MqmOfYa3jKlKpwq9ZMTdKufm8Uw/iuzMHupCRGshw+w?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <C864C1134BA0AC409A9F667C3AB2164D@oracle.onmicrosoft.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	sabsPmGYyeVwUDNgYsVjMXbDeOQG+XqDv5jY/pHxfZUWgNdRqM/QtSk3KoGwJl0YJF1WSHhdI4HSF4t3WG2wY7/XzB+RBzXIErlfksCEkvJwT4gEHEOpWHLYqsdvLv1AnJYnmwvd7VrJGML9bHf/eGBuE9s1lqGYdOPwf58jb29+oU38Vm1Mw7SMYJD0HkGHNB2ddiJSDCSGkfmWXTMu8QYu4Hc1EVrBtkFpdl3uaB5KiZtKD5rV33wlFAsy5yfaXpAhnglep5QiDV72KTWAPg0vwWpttS8P4U7iMjO7fCRBcELiuiwSKwYTIio9TMS5k3UHc7OO3LSSjyUH7Z6tOkpxrZC6Ow1+vplIq3Fgs0o3J9zZkQxnnpUZFm+qg4f62a1KeTSLQ2wD3V88EGXilkISpIWoqJQh6u8tdJq3MUAxm1BAvsnt7AUdruPahXX+jngvuOVkeol+XlHTpBjouOsI6EqwnLh2nLcKrtXpvfmuq/HB2KiLljchGTFeC8VNUxJ1rd0XfOaETcL+40CMaWrzfmjWh13G/MsaGoy4lXTVkMhfO+RTI7mYXVo5pb+oHBloJOC+PHoESng1PKaipqL5Hb+c+f877RdIsLJ5YxY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b86c848-0084-4b85-245e-08dc81851710
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2024 15:19:39.6948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xlIFM2NZopVLrt+0Do5RdCxfqjhjbcogGV/d3GD8FF/uqepayXOuuk8RIxIqkPlSY081eMh3z2t6ctGl5jojRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6786
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-31_11,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405310115
X-Proofpoint-ORIG-GUID: Q6fbmpXV3wMDAzsq6nPj5ShOFVrQstdn
X-Proofpoint-GUID: Q6fbmpXV3wMDAzsq6nPj5ShOFVrQstdn

On 30/05/2024 12:16, Pankaj Gupta wrote:=0A=
> From: Brijesh Singh <brijesh.singh@amd.com>=0A=
> =0A=
> A recent version of OVMF expanded the reset vector GUID list to add=0A=
> SEV-specific metadata GUID. The SEV metadata describes the reserved=0A=
> memory regions such as the secrets and CPUID page used during the SEV-SNP=
=0A=
> guest launch.=0A=
> =0A=
> The pc_system_get_ovmf_sev_metadata_ptr() is used to retieve the SEV=0A=
=0A=
typo: retieve=0A=
=0A=
=0A=
> metadata pointer from the OVMF GUID list.=0A=
> =0A=
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>=0A=
> Signed-off-by: Michael Roth <michael.roth@amd.com>=0A=
> Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>=0A=
> ---=0A=
>   hw/i386/pc_sysfw.c   |  4 ++++=0A=
>   include/hw/i386/pc.h | 26 ++++++++++++++++++++++++++=0A=
>   target/i386/sev.c    | 31 +++++++++++++++++++++++++++++++=0A=
>   target/i386/sev.h    |  2 ++=0A=
>   4 files changed, 63 insertions(+)=0A=
> =0A=
> diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c=0A=
> index ac88ad4eb9..048d0919c1 100644=0A=
> --- a/hw/i386/pc_sysfw.c=0A=
> +++ b/hw/i386/pc_sysfw.c=0A=
> @@ -260,6 +260,10 @@ void x86_firmware_configure(void *ptr, int size)=0A=
>       pc_system_parse_ovmf_flash(ptr, size);=0A=
>   =0A=
>       if (sev_enabled()) {=0A=
> +=0A=
> +        /* Copy the SEV metadata table (if exist) */=0A=
=0A=
Maybe s/exist/it exists/=0A=
=0A=
=0A=
> +        pc_system_parse_sev_metadata(ptr, size);=0A=
> +=0A=
>           ret =3D sev_es_save_reset_vector(ptr, size);=0A=
>           if (ret) {=0A=
>               error_report("failed to locate and/or save reset vector");=
=0A=
> diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h=0A=
> index ad9c3d9ba8..c653b8eeb2 100644=0A=
> --- a/include/hw/i386/pc.h=0A=
> +++ b/include/hw/i386/pc.h=0A=
> @@ -164,6 +164,32 @@ void pc_acpi_smi_interrupt(void *opaque, int irq, in=
t level);=0A=
>   #define PCI_HOST_ABOVE_4G_MEM_SIZE     "above-4g-mem-size"=0A=
>   #define PCI_HOST_PROP_SMM_RANGES       "smm-ranges"=0A=
>   =0A=
> +typedef enum {=0A=
> +    SEV_DESC_TYPE_UNDEF,=0A=
> +    /* The section contains the region that must be validated by the VMM=
. */=0A=
> +    SEV_DESC_TYPE_SNP_SEC_MEM,=0A=
> +    /* The section contains the SNP secrets page */=0A=
> +    SEV_DESC_TYPE_SNP_SECRETS,=0A=
> +    /* The section contains address that can be used as a CPUID page */=
=0A=
> +    SEV_DESC_TYPE_CPUID,=0A=
> +=0A=
> +} ovmf_sev_metadata_desc_type;=0A=
> +=0A=
> +typedef struct __attribute__((__packed__)) OvmfSevMetadataDesc {=0A=
> +    uint32_t base;=0A=
> +    uint32_t len;=0A=
> +    ovmf_sev_metadata_desc_type type;=0A=
> +} OvmfSevMetadataDesc;=0A=
> +=0A=
> +typedef struct __attribute__((__packed__)) OvmfSevMetadata {=0A=
> +    uint8_t signature[4];=0A=
> +    uint32_t len;=0A=
> +    uint32_t version;=0A=
> +    uint32_t num_desc;=0A=
> +    OvmfSevMetadataDesc descs[];=0A=
> +} OvmfSevMetadata;=0A=
> +=0A=
> +OvmfSevMetadata *pc_system_get_ovmf_sev_metadata_ptr(void);=0A=
>   =0A=
>   void pc_pci_as_mapping_init(MemoryRegion *system_memory,=0A=
>                               MemoryRegion *pci_address_space);=0A=
> diff --git a/target/i386/sev.c b/target/i386/sev.c=0A=
> index 2ca9a86bf3..d9d1d97f0c 100644=0A=
> --- a/target/i386/sev.c=0A=
> +++ b/target/i386/sev.c=0A=
> @@ -611,6 +611,37 @@ SevCapability *qmp_query_sev_capabilities(Error **er=
rp)=0A=
>       return sev_get_capabilities(errp);=0A=
>   }=0A=
>   =0A=
> +static OvmfSevMetadata *ovmf_sev_metadata_table;=0A=
> +=0A=
> +#define OVMF_SEV_META_DATA_GUID "dc886566-984a-4798-A75e-5585a7bf67cc"=
=0A=
> +typedef struct __attribute__((__packed__)) OvmfSevMetadataOffset {=0A=
> +    uint32_t offset;=0A=
> +} OvmfSevMetadataOffset;=0A=
> +=0A=
> +OvmfSevMetadata *pc_system_get_ovmf_sev_metadata_ptr(void)=0A=
> +{=0A=
> +    return ovmf_sev_metadata_table;=0A=
> +}=0A=
> +=0A=
> +void pc_system_parse_sev_metadata(uint8_t *flash_ptr, size_t flash_size)=
=0A=
> +{=0A=
> +    OvmfSevMetadata     *metadata;=0A=
> +    OvmfSevMetadataOffset  *data;=0A=
> +=0A=
> +    if (!pc_system_ovmf_table_find(OVMF_SEV_META_DATA_GUID, (uint8_t **)=
&data,=0A=
> +                                   NULL)) {=0A=
> +        return;=0A=
> +    }=0A=
> +=0A=
> +    metadata =3D (OvmfSevMetadata *)(flash_ptr + flash_size - data->offs=
et);=0A=
> +    if (memcmp(metadata->signature, "ASEV", 4) !=3D 0) {=0A=
> +        return;=0A=
> +    }=0A=
> +=0A=
> +    ovmf_sev_metadata_table =3D g_malloc(metadata->len);=0A=
=0A=
There should be a bounds check on metadata->len before using it.=0A=
=0A=
=0A=
> +    memcpy(ovmf_sev_metadata_table, metadata, metadata->len);=0A=
> +}=0A=
> +=0A=
>   static SevAttestationReport *sev_get_attestation_report(const char *mno=
nce,=0A=
>                                                           Error **errp)=
=0A=
>   {=0A=
> diff --git a/target/i386/sev.h b/target/i386/sev.h=0A=
> index 5dc4767b1e..cc12824dd6 100644=0A=
> --- a/target/i386/sev.h=0A=
> +++ b/target/i386/sev.h=0A=
> @@ -66,4 +66,6 @@ int sev_inject_launch_secret(const char *hdr, const cha=
r *secret,=0A=
>   int sev_es_save_reset_vector(void *flash_ptr, uint64_t flash_size);=0A=
>   void sev_es_set_reset_vector(CPUState *cpu);=0A=
>   =0A=
> +void pc_system_parse_sev_metadata(uint8_t *flash_ptr, size_t flash_size)=
;=0A=
> +=0A=
>   #endif=0A=
=0A=

