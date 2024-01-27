Return-Path: <kvm+bounces-7262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A15AA83E8FF
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 02:33:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C51611C2230B
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 01:33:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2386E9471;
	Sat, 27 Jan 2024 01:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Nfn6x9GR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pI8K7vge"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6730E2573;
	Sat, 27 Jan 2024 01:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706319220; cv=fail; b=lu7oyiJOTyWmsAPg1gQ8fUeJNV8taWnQArCXpS29W5BuOqHwTgCHLiE9ukeWWX8XRt4fLdA2khuDyn3riNCjEwQm34x9Bt2hyomjAldig8TYsOxTR1kA6ujlrmSJU6A6Nao4XD8rcSZaLWsbsfdBHxI91623XsOE5MTQfavfBd0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706319220; c=relaxed/simple;
	bh=2CXRIQQr3/GxMBSyZufDLg3FoCaKj8alSytyL7A/YMM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Z6qzqCqIex58bt3Wj4k5CjpzxKuqFt4z4pKPXYP9e6tZok7wyPQgV6beUUU0FW2SC9k6ucYodEVVCEzMHe1LsBPNMUeCnl7OKh36/lgWZAEck171yD0hMdSuNmotuKxGJUV6j2034TYYz6vBZDkEJ3O0Ms5VDlxmb2HBUIaSiVI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Nfn6x9GR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pI8K7vge; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40R1XYcQ022298;
	Sat, 27 Jan 2024 01:33:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=uVTAtP7ETM4KP0wJYErBmbr+CdvlE6tdThzm/6jGD2I=;
 b=Nfn6x9GRrwkkjvzRwzRBaCTfzqb9ljCoxJOoFwwx0Oe5M7YNDsInG6+O9Sz8LuzVKMiS
 wUihncVwgUA9i5i/ILZZ8h8EqlK0+ZSwHQVyZi9gsYpt5T7AHswRw7n7rLFyZhmOw0p3
 0KoCEJUeXa25hMqxcLBQ3484oVYkUzd9gGxTIm5Faajdb997GRs+0zMrFBtp/Dpl0qzA
 JT6wUy/PTzEywBfOJTfcOhkTyzr/NsHbMEc3tHkDBu3xsNaUDVKiOdWMWB12QyvlGCso
 Is+3tX9APsiPlhvEYfgX0+K4vEtTRYQGdp7gHnou0ObN0lDzRdgSgnVUwiiZsheLiZpM nw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvr8e800f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 27 Jan 2024 01:33:34 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40R1XHX8040487;
	Sat, 27 Jan 2024 01:33:33 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr93g0dn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 27 Jan 2024 01:33:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/wGuYbH6aON+axgsnNpGlYHuWHLH+k/p1h7Qh8/NPeV1gCjAPbW2ILH0622KO0mjhl8p4W5+PpQEmUiADRXvvkABEGdRPtF0X2M8ZSVEw57ZnuFSRPmQhj1ivtVr8p5o0BLRbzjMJWXB6O4B/0NG6M5QB0+2FKixXfmtIq+QBZEgNRpcg1nuSNZFM8Ba87LV2HKWuuK9rM7l6C8Ftn1KU2cs7d/f604fzRrZ2lvEqY2xi5oBEz+lOSgpVaaOR/vOgI4wxkfrN9p6g3FSKFJLKYyZXLR+4kIeWCkeROQX0gz6X/1l3KNafLbMDekGYJkN0/3S7BiQttozjF14v1eEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uVTAtP7ETM4KP0wJYErBmbr+CdvlE6tdThzm/6jGD2I=;
 b=ekEugG4ocGPT7oa4Tkd8GvCuDsZ+parKHGmODBUUFhyh+myyk++c9HPies246xlIunnQvnTONHipIpaIlH/tHFloiZ01GzviDNsFW8DcV3mx6R9rQfCSkb7dBLDGgRy8c1I5tZfRoe2RZ4rUz/VPnzyPFES+NsmUsgqP7DwQMGfZPN6Eo1k5bv/8hF16TINTVXnYl4TdJQw7Du/cx9fFGnaaG5wgjokCXiPlwfi0d2o9KmWW446YDcnnGyVyYyj3D7qMS1a20v44HE5nEtA5LVCm6p93540ndf0NcRkIZRFreDEQ68pcXViiFqPpuMVfbvL94YQeS0iPErbBNS+Itg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uVTAtP7ETM4KP0wJYErBmbr+CdvlE6tdThzm/6jGD2I=;
 b=pI8K7vgeNz7dEk5g02AR4cc2BH6FJ1kWfn3t3aZRVij/0YZsnN0lFtYcMi67OYahHhVaamMy+/Gt4GLBwgwbe6I5n1cpMEWyJUtkBN7GcRcP9h6YvCJ+7lBkQrfKy/Wy5dBa3qrJ6zFw7hKCW7lw3N3rfY306wgZDKVPFkM+tzQ=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by DS7PR10MB4830.namprd10.prod.outlook.com (2603:10b6:5:3ac::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27; Sat, 27 Jan
 2024 01:33:31 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6%5]) with mapi id 15.20.7228.027; Sat, 27 Jan 2024
 01:33:30 +0000
Message-ID: <79cace24-b2b6-8744-c175-bfb0a1bfc6eb@oracle.com>
Date: Fri, 26 Jan 2024 17:33:28 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: Stable bugfix backport request of "KVM: x86: smm: preserve
 interrupt shadow in SMRAM"?
Content-Language: en-US
To: Greg KH <gregkh@linuxfoundation.org>
Cc: mlevitsk@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        stable@vger.kernel.org, joe.jin@oracle.com
References: <20240127002016.95369-1-dongli.zhang@oracle.com>
 <2024012639-parsnip-quill-2352@gregkh>
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <2024012639-parsnip-quill-2352@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR20CA0028.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::41) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|DS7PR10MB4830:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a1df931-ff6e-49ad-7cf0-08dc1ed7f7fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	ZHzs1x3p7xRV5DTLnoJjI5DVl20JSbenMpkXZyhE6Aha8Ry1AbpVVPryJHUjEd/cTIvSl0iQrxPVEkqGbLs7q0CRYaEFA+BjDawr57la1VRQwoR3Z/x1hl5oT406wzeg1tEjePPhHrBhSh3M+Idth7ZDSQ/ErMJGw0M+5H3sJmKUDoqZzowuC/aEtk5MgdlqvRYRFUAJa/HBparyJhD0ZM56j24Tu3MXYbZRHlGk5wiNwVJM5GRBozVzSMMtaGSvgDNUb7caNi1D3XOh5l+Uc+4+UKg64m0lBtdC8jH/JV5h217s7CK8nWwcUAEa4xBQwFTgalHJ44YZvt1eboerXqeJn6/kHSygg8qffkPv//bL4n70VpBc/RIq6gpbARfO08kzpqpoJNzU8ChOwulacm+xWG5YIRSiy0GO9ZGhhm0boEFXJM4Vu2XMqoXUSgfH2T6J9ZDJV/y4uFqOoSJKsM8TbdeBhnR8yiTobBOPV4xd5Um+OZMpXWIo55EvZdt6clxeZTS6eqnhGNfEZY7YIr4A3e2I1C1DnfF7O2FVQHzVlH4OTyyGvOwZLL1/7kUHfRQeAvt++Jqgg6eqwZK1UDDUS9h0xcHzRGJt3MfazPlJf6Dif4m2oODPNmv5x5Rqmk0rNrwhKsDmuqbdZXXkcA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(376002)(39860400002)(366004)(396003)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(36756003)(38100700002)(2906002)(44832011)(5660300002)(41300700001)(4326008)(86362001)(6486002)(478600001)(6506007)(31696002)(53546011)(26005)(6512007)(2616005)(107886003)(8936002)(83380400001)(8676002)(66556008)(66946007)(66476007)(316002)(6916009)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?emM2b2o3aVp3citsU0pzTGxka29wTjlWUStZdUVJV0p4YkhRdEI4OU1pSFh6?=
 =?utf-8?B?eTlNOHc5UnY2TlhCWkh6cFJibldEQk5MNTF2Y3RqT2draFRhVjQzejNObk8y?=
 =?utf-8?B?aFIya3dMcnZFajUySGVHOWFaSXNvTktZbXNmS1pmNUVXSHA4eUQ3MDZoRWNt?=
 =?utf-8?B?ODBvNGVCai9GTWRuckw2WnpXbzd3ZHNYZDlNemcva2N0emV0RTZUUjJOZDYy?=
 =?utf-8?B?K2t5THFGNllrMEZ1N2l5SDVnVHRRVGZzRDF2akFpS21RM2MvNHR1cTNjUlZN?=
 =?utf-8?B?Vy9UQndTU2V5OWViejZ4cnBVeXVyMFNWKy8wK1A4WkJpczlVaUpGWDVvY2tZ?=
 =?utf-8?B?NTg4KzNjd2dXdExUcTg0b1FhZlg0RkhyOW5hd2NWYnJ2MlFreHAyUHQvQW5G?=
 =?utf-8?B?SXhKcHd4S2pqbFJrTmZ2Nm12WlhtRzd6OCtQNFFjN29kYzJKWjBnd0dnVzdp?=
 =?utf-8?B?aEJHNm5DVE5MNURHV25lTktEekNiNk1BUVNOQ2dMZjU4dDA3Q0ZLcEtPWWxx?=
 =?utf-8?B?bjFNa2JwRUFsczZZdi91WU5XYmliSUxBTG13a2VndlBTQkhSY05ZcElQZlU2?=
 =?utf-8?B?aDk5Slk2WE9sOWpnbnI3MnlCUWdpZ3dGUldBaXIvY0I4SlQ4N3pGaFVNZ1RH?=
 =?utf-8?B?RTRPV1NSV1k0dG5RU2hrQ0lEQjcxaGRvTUNCUmFGdjN3OGtYT1FYS1V4MnJz?=
 =?utf-8?B?YVJudnVTcWlsUzMxRkRseVJ5c3pLa3N1SnAzOEY3VVZCZ3FoY1BSV25Vbmht?=
 =?utf-8?B?bFdHVzVoWTRYakZzZUI2QXdmNTZ6NTRIaGwyTVptNFhTdTVvMFRTSDMyQ0tj?=
 =?utf-8?B?Y0dZT3ZySlRzb2tDUi9JWmRUSEdUR0FQendXd0RzNlVEVFFIdHhGRFJTbkZy?=
 =?utf-8?B?MW1SZnRQSWw4RFVhRTU1cStpTm4wcXFyVmxxMmN5eEl4d0hxazFqK1hvNE1l?=
 =?utf-8?B?QjNDWWRXbDQzdlExZmhXdXhYOFhsUWl1VG9tWDdONG1iMVRUem1CNUdmQ3lo?=
 =?utf-8?B?WWprSjh4WTczTUNJcHZHM25nT0Z1NktERWlLeDdYLzdxNmFIKzE3RDBBVHJJ?=
 =?utf-8?B?R3EzeHFwREYvbVpJQTUxRkJHZHdFSDhNL1U1ZVJVME05QlJrTEZtd0UwVzRZ?=
 =?utf-8?B?MklhZms1YktCSWJrNGpILzg3TmVJamFVSGtHY29NOUtDM1BBazRpcEV0WDFj?=
 =?utf-8?B?TmVmd2FqSCtTSXJoTTR6UFVCNHZGRVhOcjl2MU1WY0xNeFdabjE3NFlzSGwr?=
 =?utf-8?B?OWFlNGlXQUdXZSs3b3M1Ujg4ZUNUL0NNMlBkY2taT01rQU1BdmVNS3NFL2w4?=
 =?utf-8?B?VDlXNHI2OHRQeTRTaHZyNk5BRHpGemYyMThoWHhmSEFGby9TVlFmbDMwSHRX?=
 =?utf-8?B?NUdIMFJxZVRQNnZYc1EyaVNHV2IrVzNWTlNPcmExUEJIVkt2MDJpcHUrY3JE?=
 =?utf-8?B?aFFtZHk4QjdsdWdmUHl4VHdGc3ZmdXZHaVdUZ0hpQ1BlV0poTkUxVHlQb1JD?=
 =?utf-8?B?MDJVOFd2a1ZXeHFFemFvMU1GWEJjei83ZE5WMFNyRzA1cUp3SXZxbXNtU2hD?=
 =?utf-8?B?ZnRDakN5OWxCWVpQbGZ3Uk8wT3ZNb2JhQ1ZpdDl0bUJLM09wTjhRdHREcVF1?=
 =?utf-8?B?OGlTdzlqN08zb25MYzJwVkx0NUdVUzdaUEorUkd2S1pNU0xYTmhoWlJxaVpD?=
 =?utf-8?B?aWNpQ1JqNHEzY3h2SXh6K0tZZGZ0eU1PeDhUdGI1d20xb0kxL3Bvc0tpQVdp?=
 =?utf-8?B?b2UrMWVjaFp1bzVDdWlSeE5aYnBhUnhGRm9KTDVTQmxTOEdVcHdEUzBPMTgv?=
 =?utf-8?B?aEFvbGtac0IvYXErTW9uaHZqVnIxSXhZQjNiR2xsbm5QQ3JaTk1kdG9GdFFZ?=
 =?utf-8?B?MGI2dmZWNWNXUytPazdiVnFLSUhnUkQzcGpCR3R0cUZVRkNDUHdDalBpNWZH?=
 =?utf-8?B?LzF2NUpSTGZNaldqTTAvZ2pPb3JrZk1JOWR2QWtwbDcrTjJjNllocUNVbUt5?=
 =?utf-8?B?RnYrdDlUbWZya1VwbXU1djhCSGRBU1VFNGZYWjl0OGhPVmJoR2x6SWJIc2kr?=
 =?utf-8?B?TTd3RU9KQk1mcVo5VlZyT0FrTkFtZElyNUtLNXQvbVk0bW5jWmlta1IrbEZR?=
 =?utf-8?Q?dSFyUm7o6ic4nJZUQ33VwPjz7?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	CxQ/y0pLjKJEN6yw0ZfZ3zURoHba4mSUM8xoXhq6gmTgg5pHfdufSqY5WCi9G801pbDzURciCfshbMaYVniV/7z3DzH/5f6pSg5I72N5ZmZQ4tO2PjIZQGckwnsyRjnjTF1Ou6z0ceO+ExbHiCyb0bB1kSleKDvDSHlFU5UE0mOOgvQYnFbsZn8Lz1d/45N+mpdIApzOHawA+mfhHZycWqjVz6hAvGOXylXz0qT/0By3B//nIPi7zXAaekrFUMaUUmXJh2EiD6Ljs5157dJd7yKwfNaWffEKw+JoivhyQWia10JRxa/hjokS0xw/oPQcJZ30jTAeHY+rSBOTMBoDizjRSF7361BjPR2iI1vTFH+B/Ppy3zwdVym7CxH/J9p9RB1E9tbX7WA6yNEFvtIn+1FN8Pd8sXvJLdWk0mmu6hwn00zsEdPYLPtFRnDUqFmxvtkPVEV0lAD/oPzHArJWaHTHtScwMepxEjIrWBM9Gqm1ad1wsuTMufKc0V1LWB8eSYutYybhGnLLnheK2ivxIMtYQy+Ryzx5n6kNY2HMYGGt/3WF1WJrcDz0Im3/4A6R7Tm4YuMPS7D6Qo3kdHwFrennPzM05i77IlD1gA34sNo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a1df931-ff6e-49ad-7cf0-08dc1ed7f7fa
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2024 01:33:30.8073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hOnoFZrwfCvf+qjAlJx6cf5KM3hcMwj05bNoJWpEE7qoucX+2EtOukRCWK+F0YVNwBNLcir5LvSkCKD3Y0WoYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4830
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-25_14,2024-01-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401270010
X-Proofpoint-ORIG-GUID: JDmPrkj5kBkqDc-Tl3ODzslamIgtteKG
X-Proofpoint-GUID: JDmPrkj5kBkqDc-Tl3ODzslamIgtteKG

Hi Greg,

On 1/26/24 17:08, Greg KH wrote:
> On Fri, Jan 26, 2024 at 04:20:16PM -0800, Dongli Zhang wrote:
>> Hi Maxim and Paolo, 
>>
>> This is the linux-stable backport request regarding the below patch.
> 
> For what tree(s)?

It is linux-5.15.y as in the Subject of the patch.

However, more versions require this bugfix, e.g., 6.1 or 5.4.
I have a backport for 5.4 as well.

I just send the version on top of 5.15 for suggestion, or there
is already a backport available.

> 
> And you forgot to sign off on the patch :(

I have a signed-off after the commit message. There are some conflicts:
e.g., the smram buffer offsets used in function calls.

I have added the commit messages to explain the conflicts between
Paolo's signed-off and my own signed-off.


BTW, I have created a kvm selftest program to reproduce this issue. Although I
cannot reproduce on baremetal (perhaps it is too fast), I can always reproduce
on a KVM running on top of a VM.


$ ./smm_interrupt_window
Create thread for vcpu=0
Create thread for vcpu=1
Waiting for 2-second for test to start ...
vcpu=0: stage = 1
vcpu=1: stage = 2
Start the test!
==== Test Assertion Failure ====
  x86_64/mytest.c:96: exit_reason == (2)
  pid=5541 tid=5544 errno=0 - Success
     1	0x0000000000401dd3: vcpu_worker at mytest.c:96
     2	0x0000000000417cc9: start_thread at libpthread.o:?
     3	0x0000000000470d32: __clone at ??:?
  Wanted KVM exit reason: 2 (IO), got: 9 (FAIL_ENTRY)



There are below in the dmesg.

[  165.292990] VMCS 0000000088f567e4, last attempted VM-entry on CPU 14
... ...
[  165.304272] RFLAGS=0x00000002         DR7 = 0x0000000000000400
... ...
[  165.329264] Interruptibility = 00000009  ActivityState = 00000000



// SPDX-License-Identifier: GPL-2.0
/*
 * Reproduce the issue fixed by the commit fb28875fd7da ("KVM: x86: smm:
 * preserve interrupt shadow in SMRAM").
 *
 * The vCPU#0 sends SMI to vCPU#1 that is running sti to trap into the
 * interrupt window.
 *
 * Adapted from smm_test.c
 */
#include <pthread.h>

#include "kvm_util.h"
#include "processor.h"
#include "vmx.h"

#define SMRAM_SIZE 65536
#define SMRAM_MEMSLOT ((1 << 16) | 1)
#define SMRAM_PAGES (SMRAM_SIZE / PAGE_SIZE)
#define SMRAM_GPA 0x1000000
#define SMRAM_STAGE 0xfe

#define STR(x) #x
#define XSTR(s) STR(s)

#define SYNC_PORT 0xe

#define NR_VCPUS		2

uint8_t smi_handler[] = {
	0xb0, SMRAM_STAGE,    /* mov $SMRAM_STAGE, %al */
	0x0f, 0xaa,           /* rsm */
};

static inline void sync_with_host(uint64_t phase)
{
	asm volatile("in $" XSTR(SYNC_PORT)", %%al \n"
		     : "+a" (phase));
}

static void guest_code(int cpu)
{
	uint64_t apicbase = rdmsr(MSR_IA32_APICBASE);
	int i;

	wrmsr(MSR_IA32_APICBASE, apicbase | X2APIC_ENABLE);

	if (cpu == 0) {
		sync_with_host(1);
		/*
		 * vCPU#0 keeps cli/nop/sti
		 */
		while(1) {
			asm volatile("cli");
			asm volatile("nop");
			asm volatile("nop");
			asm volatile("nop");
			asm volatile("sti");
			asm volatile("nop");
			asm volatile("nop");
			asm volatile("nop");
		}
	}

	if (cpu == 1) {
		sync_with_host(2);
		/*
		 * vCPU#1 keeps sending SMI to vCPU#0
		 */
		while(1) {
			x2apic_write_reg(APIC_ICR, APIC_INT_ASSERT | APIC_DM_SMI);
			for (i = 0; i < 1000000; i++)
				asm volatile("nop");
		}

	}
}

static void *vcpu_worker(void *data)
{
	struct kvm_vcpu *vcpu = data;
	int stage_reported;
	struct kvm_regs regs;

	pr_info("Create thread for vcpu=%u\n", vcpu->id);

	if (vcpu->id == 0) {
		vcpu_run(vcpu);
		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
		memset(&regs, 0, sizeof(regs));
		vcpu_regs_get(vcpu, &regs);
		stage_reported = regs.rax & 0xff;
		pr_info("vcpu=%u: stage = %d\n", vcpu->id, stage_reported);

		vcpu_run(vcpu);
		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
		memset(&regs, 0, sizeof(regs));
		vcpu_regs_get(vcpu, &regs);
		stage_reported = regs.rax & 0xff;
		pr_info("vcpu=%u: stage = %d\n", vcpu->id, stage_reported);
	}

	if (vcpu->id == 1) {
		pr_info("Waiting for 2-second for test to start ...\n");
		sleep(2);

		vcpu_run(vcpu);
		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
		memset(&regs, 0, sizeof(regs));
		vcpu_regs_get(vcpu, &regs);
		stage_reported = regs.rax & 0xff;
		pr_info("vcpu=%u: stage = %d\n", vcpu->id, stage_reported);

		pr_info("Start the test!\n");
		vcpu_run(vcpu);
	}

	return NULL;
}

int main(int argc, char **argv)
{
	struct kvm_vcpu *vcpus[NR_VCPUS];
	struct kvm_vm *vm;
	pthread_t tids[NR_VCPUS];

	vm = vm_create_with_vcpus(NR_VCPUS, guest_code, vcpus);

	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, SMRAM_GPA,
				    SMRAM_MEMSLOT, SMRAM_PAGES, 0);

	TEST_ASSERT(vm_phy_pages_alloc(vm, SMRAM_PAGES, SMRAM_GPA, SMRAM_MEMSLOT)
		    == SMRAM_GPA, "could not allocate guest physical addresses?");

	memset(addr_gpa2hva(vm, SMRAM_GPA), 0x0, SMRAM_SIZE);

	memcpy(addr_gpa2hva(vm, SMRAM_GPA) + 0x8000, smi_handler, sizeof(smi_handler));

	vcpu_set_msr(vcpus[0], MSR_IA32_SMBASE, SMRAM_GPA);
	vcpu_set_msr(vcpus[1], MSR_IA32_SMBASE, SMRAM_GPA);

	vcpu_args_set(vcpus[0], 1, 0);
	vcpu_args_set(vcpus[1], 1, 1);

	pthread_create(&tids[0], NULL, vcpu_worker, vcpus[0]);
	pthread_create(&tids[1], NULL, vcpu_worker, vcpus[1]);

	pthread_join(tids[0], NULL);
	pthread_join(tids[1], NULL);

	return 0;
}

Dongli Zhang

> 
> thanks,
> 
> greg k-h

