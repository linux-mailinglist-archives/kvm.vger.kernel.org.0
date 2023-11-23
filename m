Return-Path: <kvm+bounces-2366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 001A87F63D6
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 17:22:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 237BE1C20BB5
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 16:22:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC6F03FB0E;
	Thu, 23 Nov 2023 16:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aXanxBMN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vo7tHg1z"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7019AF9
	for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 08:22:46 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ANFrvTF002470;
	Thu, 23 Nov 2023 16:21:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=3uPng5VJLLghWoGP9dOMb4fXlSeVDRMrdTQl016Qycg=;
 b=aXanxBMNCdQ3k/CpB1GUwu6xGqbtuA9CrjPlSjv6Sqbbp+ggqcraPI5VVe3HzMJr/J7l
 R2nsWMIWevgTuTEGXAJBmmgDTqMzGejx3WdGRe1f9BsflaH6mWYDZlKvHdX+ifiGZHck
 nKqgpi0X3O5wvhj9YaHBAcDR0tbO+SFL69l+T1RnY7KQcD2+Hykll+bB9JPWQceu7bJN
 dtiheBt63UMStVA547rdb+dzP59C1eVbqx/sqkIpzxMo5jS/ddwkpGBPck+/PnWFrBAR
 CdQ79PWsBPkXsnwRceI7UQv1L871P8gMKRgSYaQq+RAvsWNDGveyRWL4TmFhbFuUsg0V DQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uenadt3md-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Nov 2023 16:21:58 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3ANEqKoi007333;
	Thu, 23 Nov 2023 16:21:58 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uekqagpsy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Nov 2023 16:21:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HHq4XtKsAH9oytxq798LNshJN+XTZIY13ROZpj/m4B5lXJ2gdET9wv5At5f8F0/mLEzahyJ8oFUfl2uYn6uwGxnk9lldHNIFbvpV7Rx47BLt38GpNr/WICRI0Z5PQ3EjZH3QgjmJUbkZUSXGVc25tnRAPv/JykRNf0akxApkk+fFg2GVJWhJJk+5cPPCU+SyoYM/kZqnWV9ZoPtaCxCfkw5v2BPPq/3HA/LpOJS6F6ev+BVWGpxT7mn+PUuBcJoDyIWT5Nh/NphsetRLtxun05jSFWGPYnz1zQc7n8SfzERVqtuPggh9WgYtkruhnaYFeufJN2daMzjaTIR2BC1MmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3uPng5VJLLghWoGP9dOMb4fXlSeVDRMrdTQl016Qycg=;
 b=OC/Gxq01080tKGlF3qj9UsGbvGBol+075c+7Zj/5D3DRvyKCiXZ5dJ4d0qHPHZ9d+lBKXy0Xa0XoHumfqgLFzT5V18Onsc1KLbxHBHOHLz2THyKvymz36Oj3KC2UIaD1hUSBWbEdcs7R9lxZnwVWQj+7Nr8Sx14IRipfPRov0Zns4ZVGwtdBYBGpJGF+Rela7InHMidmTgoYVvx6hfdphXKgF4gXlv+J8oqkD6QhO4oGKOxSBZ8DJbA3/79qRqtLgEDnK531QqPLfrZeP31dcIZWFuyZ+xTQ/r7U0lSKsQ5hTHnh7bHjZ8D3X/5sL2diLI+TxFDwkpKfevLfOqUmlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3uPng5VJLLghWoGP9dOMb4fXlSeVDRMrdTQl016Qycg=;
 b=vo7tHg1z4yJk8TgGXsASd+h6IrhH+2PCu6POzCbi7/Wh7ZPYRZPnjLX0WdWE6upB+qHQ/XwuLQllOHlqRBWYRPKmpjWKtwZAijh89+BNv3QZFAD8ypV94L4yro/1lvyKHpb8x2jc+JeuUcLVG/XxRgWL3ekR4zqYNBoZIBXgabg=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by DS0PR10MB7456.namprd10.prod.outlook.com (2603:10b6:8:160::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.20; Thu, 23 Nov
 2023 16:21:56 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::cef0:d8a0:3eb1:66b2]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::cef0:d8a0:3eb1:66b2%4]) with mapi id 15.20.7025.020; Thu, 23 Nov 2023
 16:21:55 +0000
Message-ID: <05733774-4210-4097-9912-fb3aa8542fdd@oracle.com>
Date: Thu, 23 Nov 2023 15:21:48 -0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/43] KVM: arm64: Nested Virtualization support
 (FEAT_NV2 only)
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
Cc: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse
 <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
References: <20231120131027.854038-1-maz@kernel.org>
 <DB1E4B70-0FA0-4FA4-85AE-23B034459675@oracle.com>
 <86msv7ylnu.wl-maz@kernel.org>
From: Miguel Luis <miguel.luis@oracle.com>
In-Reply-To: <86msv7ylnu.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0228.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:315::16) To PH0PR10MB5433.namprd10.prod.outlook.com
 (2603:10b6:510:e0::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5433:EE_|DS0PR10MB7456:EE_
X-MS-Office365-Filtering-Correlation-Id: 77993954-e915-422c-2ea9-08dbec404f08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	khTpEITJmxBVK64zRjRTNA7Qz2Mdv6dgXl4ltItn6dAAVK89I0ZL/90twRSv6DnkruVTEXYwF4sQ+9ZYmZgDTSabwgTVzEgmB3w3JH/d6u801p487QHhgZlOLI9ODNbaT5B9bssMU380TuzI67B2HdRrY8QJ2QqV2bIjiJ5ql2jdTwm/U0SCM9dwtDUkewEOQ1+8s45jGjCCaTrx0bv9X3HAvJCmKTieSkkWWN3e8zPx3CqAYUXnQHCtDg1GHMt98XixfPjNUGh16sjm6eU17sbJ81Fn/MgUNoodF091hlRuLRGmJzyN7gAB9toxscCFax/R/NHbfOLIePPoXEPKZ2lwFPBEe67CJ5DkCc8qOzEgCwsgBSgXZd3bdfJ4VPlmWfrYS7PXyz1+JpBAh73/GrrZP9VEeiV8bByYqFEDCIQd4MglEtuq0akOHf35dreRYvZloxq68a+u0qMo8Bp8jy4vuxcucDDxWKctiL58aPfDt/I3PwtfmmzvEPa4geFYgE27ChW0Y7zE+tIX7CyxRCdD6/iZervVuYb8s1CCZGQ17ojkHaPEm3sB/zlBMsdTIY6fcw6sASxWjm0A22EfkTVaa74L5acpMP7gSpj5jdEAY0Vdm4LTzkkDDvVfCjx3eX2DXuY6/yMhMspSy0nfHmuYFOFcPuOkMhhfR3XG287ixifFSxojIdpFJFM/kfZA
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(396003)(39860400002)(346002)(376002)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(5660300002)(7416002)(2906002)(66946007)(8676002)(8936002)(54906003)(6916009)(66476007)(66556008)(316002)(4326008)(41300700001)(6666004)(6486002)(6506007)(478600001)(966005)(53546011)(31686004)(44832011)(26005)(2616005)(6512007)(38100700002)(83380400001)(86362001)(36756003)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?TmpDOHN4Um1hNWlnbVUyNm42TEZiR2Znb0tXYkdFK1h5ajJ1b3gxbW5jTnRu?=
 =?utf-8?B?dzdDMDVOcUdwQit2WEZKdGxpRCtXd1p5UUZrK2FGNzI4MHJNeE02M0hHVUcw?=
 =?utf-8?B?Wmw0WlpVZjExc3hHU3RUK05jeHMwQVN0b3g1NnFZVk1PRUZvZGV2am9tNXJk?=
 =?utf-8?B?eDR0TWV6K0tGTk5oZFZhQ0RoTTJHdTdoeFZoZThrdDNqYkxvQ3ZtS09wWkll?=
 =?utf-8?B?RnVpY21uLy8yUGU2R2tRRVlaaDBVRHJRMHNObWVSNjFSL3hTVXNjSVVwWXMy?=
 =?utf-8?B?aDRrNVgrZkgwc3g5TGR5eEEzVlMzcGdsU3ZQZ2ZtM1JId1NkTXVCZzNOdWs0?=
 =?utf-8?B?MHlGSDBoSHkwMW83NnRvSzNjdDlkUS9RN1NBZy94RGVqTDlOcHltbUd5dE1P?=
 =?utf-8?B?T3YzczVIVGhZSWJXTVB6MGxWTHhVZmRTRVNuY1ZBblExKzExZDJUZFdFUDdh?=
 =?utf-8?B?Tm1HV1ZZYXIwdks0ZWR5a0U0TFhXUERnTlQ5c0hzWm01bE94ZjhCcVZVeGwv?=
 =?utf-8?B?dzRsQTdrc2x3bHp1bklPWmdPK21EbThqKzlkVWY5eFhQUDcvZ09pcmVFR28y?=
 =?utf-8?B?YVdXamRwZFFCeVoyNkhWYUtxUDE3dTVqeWEzWnFUemdlRTBBbW55ZGd4V3li?=
 =?utf-8?B?bEsyNm83NTQyQkkvem9idmVXQjlrMFl0Ym9ZTWEzS28vSzRHcTRGUVNmb1Ni?=
 =?utf-8?B?N2xBdVhEWTNPcWdMTk03azZ3WkxhWnZ5Z21sV1VaK1lmN2V4aXVGQU5sb2Qz?=
 =?utf-8?B?cVhKd3Q5SDM3cW5rWWlkQ0o1Q2RkZ3g1YkZUNlF3RnZYQkJWUlBESUFlWFkw?=
 =?utf-8?B?ZWR1bE0xVVU1Z1p4ZW9IT1BCNmNveGFOVTYraWVyVXBWMW9yY1Brc2RZbWw2?=
 =?utf-8?B?OFN0ZzNub2haNUdkNlJQc1RwYmV6dWxBWmVEcm0zNnhLZGxLNWNLZ08zUU85?=
 =?utf-8?B?LzdtYzB3b2F2MjVPSjh2WXcvVmVuN0g0aTJWN05ENlNVQU1UMFZSaGtFVjVZ?=
 =?utf-8?B?eHVkL3phTy9VZ01YY2hCR3F2WDdMT1VsT3hwK0Q4RHRLY3JLSUhRTjl4ZHY4?=
 =?utf-8?B?dFRERTZmb09KTThndlZ0MU82dTlpWG5wbSt1UWlJOWRscEFEblN2R2ltNVpX?=
 =?utf-8?B?dEY0YkNZNkcwd2Qwa2NrT1JQbi9pbzBMeTR1Vy9BT0RTRld3d0w1c1Brb1Vz?=
 =?utf-8?B?NS84OU9xanpmWHdaTzBvL1hibFdvYi9PT3UyTHMxZnBBazJQL0ZQTjNPai80?=
 =?utf-8?B?TDZPaWx2TU1GSXFKY2cxcVhUVWVwd01BTDNDYjVGOFA2amJSaVpiUHZNV3Zh?=
 =?utf-8?B?eURGblFaVVkrRnF6MmVRbmNNSjFQeHJRcWZ6S0ZvQm9sR09hTEVVdDZ2SjdR?=
 =?utf-8?B?QktiendQTHRFdE5SZFR2UE40Z0ZST3RibUZ5ZVlFQTh6eHhKWER1SDZGMDVp?=
 =?utf-8?B?ekVlRmdwQXpySzFsMjVwVEN4by9XaGVnZWs1d2RTNk52enZiSEIzQTZheFUr?=
 =?utf-8?B?dlE1RDVtaFpwZ0c3K2VBUFdiQ0pOUHNrV3YzN3UydHdLdE84eWV1RVhSQzZi?=
 =?utf-8?B?Wmd4SjkzdWhseGtXL2FyMDBDQU9PN3ZEZ0x0eTI1UEFpcEl5V2NlN1ZoTnVQ?=
 =?utf-8?B?NlIzci9IZU9nZ2tSUFIwZ3NBQ3VnUDFORS9LMlZSYlY0V1FFTXFpeXdxOFUr?=
 =?utf-8?B?YVNkbTBCRU4wUG50ZjkxQVpQRWI2b3FzbjVVdWY2U3NPZ09GZ1R0NnE4eFgr?=
 =?utf-8?B?bG5YNFZaUysyOUgrMldRaVhhRm9ROWRBUlBXbU1QVVExc3kxemJFNUVDUWNG?=
 =?utf-8?B?SXFXUDQyZ0pIOTZoOVIwNnRmeGtxVUxyVVZJTnVvMHhyQ05VSm1xcDRxRFVT?=
 =?utf-8?B?dlZTNzM3Z2RBM0d5bVBnQU9kZ3FHQkczamRaM1g4dmdtVEdhaWhJTTdDWFBK?=
 =?utf-8?B?MmdWdG1PaU5hK3VRNE43VnVHb2ZvMUphaTY5cFZWcWY2b0dNRVlKcGhwbXVN?=
 =?utf-8?B?NnZ1MlVFd2tvWHRkcmJiTnVtZ1RKR05uNXoyQlU1S011TWwxSHZ5RHFPUlRL?=
 =?utf-8?B?VnNBWk9QV3BLVVN2N2hFd1FOZ2U4Z3RhYko0ZGlkNXpFVkJnRmRXZGlNNXRm?=
 =?utf-8?Q?iXtVokBpAWA0LL7pU2OHn1ppf?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?utf-8?B?eFlieVpVd2FPcjlsNmhRUXFZanU3UlEyaDBWODVXSXBNaGdGek01VWJsSHdw?=
 =?utf-8?B?QWh1RDlsc0ZPb0xVZ3pGWlBsMWpQb0MwZnd2bElNcG1VdFYyRVBhZ25kSEY3?=
 =?utf-8?B?OTVLaXM1dEpFTEpuWmwyVWFVd01HUFBBYTNMb2c4Q3oyUnNMQTlydTRRcnZp?=
 =?utf-8?B?ZGlDdGVLOVJ6cDk5aEhTRElOVHA1UWR0K3RKend3RWQxMVFteENHbVUwT0V2?=
 =?utf-8?B?c0VHYVJ4SG9WZlQ0QWJNTDlSNkM0RTJkY0Z1SEVTVUlDYnV6OEIvcjE3bXRR?=
 =?utf-8?B?VmJuWVpFV29LdTVRZWptVURDZHFYZXltdUdLLzFOUW51QU1yYnZXWDVFNmRt?=
 =?utf-8?B?am13ZWttbk9pNk5teXpwMEhPV0o1S3ZBdlpMQ1lXZE4zdU9kSE4rU2lTR2hR?=
 =?utf-8?B?MTJ3dHNzTlVWRytmTVpKN1pmZXpEd0tZZmcwcFRSNFJRWHp2dkNRZGx2VjJq?=
 =?utf-8?B?R2Y4ZWlJYmNCUWJGb1U1RytWV21PbldMMWlBd1R5SDhwQ08zTVhuaW1rSE5k?=
 =?utf-8?B?WTVGSVdaUGlNcUppZXFQNys5eEd3QWQ5YlJ5SFN4a3VlMnh3a2hqN0ZNMjY5?=
 =?utf-8?B?dzk4ZFRKc0FTMWF3WGVORTFJWUljUEMrblZoRzRDbGtjUEFCQ1Q0VmtmNFg0?=
 =?utf-8?B?aS9xaFF3M2R2TmdQL1BadU9kQWV5OVVuUnhlbko0ZDZBa2NDbis4TUJldGJl?=
 =?utf-8?B?d2h2WERtRjNYN0dNcEplRlhuaml5VHJUTGxUeTFKK2ZCdW9TYkZZQ3pQWEFh?=
 =?utf-8?B?UTVVdWFiRE5kRVFHMkMzdzg5SzFvd3lDMUpDc1R1VXZVWnNBQWlxOWxqckk1?=
 =?utf-8?B?enh1L1BkZDJMMG8zcHpBSG0wbkZUaWdqRVYxRHdlaGhsV1I0cjRTMk45T3V4?=
 =?utf-8?B?c0txWDJLUlRrQkw1MUY2bmlSeGNYMUlJdk5iMHdVU3hFYnhvUjJVMnI1T3FR?=
 =?utf-8?B?RW9QdVdOTVRiaThQQzJOWGhnNzdEckc1ank0UkEweFRjY3VZZWwzeGgwRmEv?=
 =?utf-8?B?OVNTWjA3cU1IdURRb2IvbjhxVFI4OXRxTEg0d3dpWWpOUHdKTkRPUnA4VEVr?=
 =?utf-8?B?d1FwcGQyMThCa0crbWI1Yk5mV2xxeWJKR1R5enkzeVJpSWlyVXlxNXhzdjlk?=
 =?utf-8?B?UUxwZng5ZHVRMnh0VVJnT0psNE1xVWRZRmVWNDM3NmlnOENxTHp6YjE4YVYw?=
 =?utf-8?B?WEFjNEpXQ1pFandLVkNQMlJ4RVBhUElzcndFcTFuV2pxTXo1Z2hWOVBIOXQ1?=
 =?utf-8?B?ZVVuSUNyTFFDTXZzM0I5REZMT1VaN0xUSXc5aTFwVCs0T1BBYXdRYlpnZ0g3?=
 =?utf-8?B?UFBNbDBUWi9nN2NlN0xYN3kvQ2ZZY3ZaSENHOU5OZTlITEJUdXRDNWgvY2Q1?=
 =?utf-8?B?ejZhaGsrcko5blNWeko0ZFgyYTRSeklzckpXejFBelQ1L29aOG4yYUJJTjZy?=
 =?utf-8?B?MjNySDcvcFo1QVk2WWd6SFI5Y1hyN2lucldXT2FwNXRQZWpDclNNN3VyTzRY?=
 =?utf-8?Q?nPCZyI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77993954-e915-422c-2ea9-08dbec404f08
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2023 16:21:55.3867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YWUfqAlGvCg/QbmoFJIsBh/TtUtid1QzWf9gLp0CKZJU4kXsw41WKQiBTFVMs/yUb+9WakqK5cCoa1AJa0/Uqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-23_12,2023-11-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311230119
X-Proofpoint-GUID: nYVUrRyqa61QGBEJE1GMPnFFkTxJXtj5
X-Proofpoint-ORIG-GUID: nYVUrRyqa61QGBEJE1GMPnFFkTxJXtj5

Hi Marc,

On 21/11/2023 18:02, Marc Zyngier wrote:
> On Tue, 21 Nov 2023 16:49:52 +0000,
> Miguel Luis <miguel.luis@oracle.com> wrote:
>> Hi Marc,
>>
>>> On 20 Nov 2023, at 12:09, Marc Zyngier <maz@kernel.org> wrote:
>>>
>>> This is the 5th drop of NV support on arm64 for this year, and most
>>> probably the last one for this side of Christmas.
>>>
>>> For the previous episodes, see [1].
>>>
>>> What's changed:
>>>
>>> - Drop support for the original FEAT_NV. No existing hardware supports
>>>  it without FEAT_NV2, and the architecture is deprecating the former
>>>  entirely. This results in fewer patches, and a slightly simpler
>>>  model overall.
>>>
>>> - Reorganise the series to make it a bit more logical now that FEAT_NV
>>>  is gone.
>>>
>>> - Apply the NV idreg restrictions on VM first run rather than on each
>>>  access.
>>>
>>> - Make the nested vgic shadow CPU interface a per-CPU structure rather
>>>  than per-vcpu.
>>>
>>> - Fix the EL0 timer fastpath
>>>
>>> - Work around the architecture deficiencies when trapping WFI from a
>>>  L2 guest.
>>>
>>> - Fix sampling of nested vgic state (MISR, ELRSR, EISR)
>>>
>>> - Drop the patches that have already been merged (NV trap forwarding,
>>>  per-MMU VTCR)
>>>
>>> - Rebased on top of 6.7-rc2 + the FEAT_E2H0 support [2].
>>>
>>> The branch containing these patches (and more) is at [3]. As for the
>>> previous rounds, my intention is to take a prefix of this series into
>>> 6.8, provided that it gets enough reviewing.
>>>
>>> [1] https://lore.kernel.org/r/20230515173103.1017669-1-maz@kernel.org
>>> [2] https://lore.kernel.org/r/20231120123721.851738-1-maz@kernel.org
>>> [3] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/nv-6.8-nv2-only
>>>
>> While I was testing this with kvmtool for 5.16 I noted the following on dmesg:
>>
>> [  803.014258] kvm [19040]: Unsupported guest sys_reg access at: 8129fa50 [600003c9]
>>                 { Op0( 3), Op1( 5), CRn( 1), CRm( 0), Op2( 2), func_read },
>>
>> This is CPACR_EL12.
> CPACR_EL12 is redirected to VNCR[0x100]. It really shouldn't trap...
>
>> Still need yet to debug.
> Can you disassemble the guest around the offending PC?

[ 1248.686350] kvm [7013]: Unsupported guest sys_reg access at: 812baa50 [600003c9]
                { Op0( 3), Op1( 5), CRn( 1), CRm( 0), Op2( 2), func_read },

 12baa00:    14000008     b    0x12baa20
 12baa04:    d000d501     adrp    x1, 0x2d5c000
 12baa08:    91154021     add    x1, x1, #0x550
 12baa0c:    f9400022     ldr    x2, [x1]
 12baa10:    f9400421     ldr    x1, [x1, #8]
 12baa14:    8a010042     and    x2, x2, x1
 12baa18:    d3441c42     ubfx    x2, x2, #4, #4
 12baa1c:    b4000082     cbz    x2, 0x12baa2c
 12baa20:    d2a175a0     mov    x0, #0xbad0000                 // #195887104
 12baa24:    f2994220     movk    x0, #0xca11
 12baa28:    d69f03e0     eret
 12baa2c:    d2c00080     mov    x0, #0x400000000               // #17179869184
 12baa30:    f2b10000     movk    x0, #0x8800, lsl #16
 12baa34:    f2800000     movk    x0, #0x0
 12baa38:    d51c1100     msr    hcr_el2, x0
 12baa3c:    d5033fdf     isb
 12baa40:    d53c4100     mrs    x0, sp_el1
 12baa44:    9100001f     mov    sp, x0
 12baa48:    d538d080     mrs    x0, tpidr_el1
 12baa4c:    d51cd040     msr    tpidr_el2, x0
 12baa50:    d53d1040     mrs    x0, cpacr_el12
 12baa54:    d5181040     msr    cpacr_el1, x0
 12baa58:    d53dc000     mrs    x0, vbar_el12
 12baa5c:    d518c000     msr    vbar_el1, x0
 12baa60:    d53c1120     mrs    x0, mdcr_el2
 12baa64:    9272f400     and    x0, x0, #0xffffffffffffcfff
 12baa68:    9266f400     and    x0, x0, #0xfffffffffcffffff
 12baa6c:    d51c1120     msr    mdcr_el2, x0
 12baa70:    d53d2040     mrs    x0, tcr_el12
 12baa74:    d5182040     msr    tcr_el1, x0
 12baa78:    d53d2000     mrs    x0, ttbr0_el12
 12baa7c:    d5182000     msr    ttbr0_el1, x0
 12baa80:    d53d2020     mrs    x0, ttbr1_el12
 12baa84:    d5182020     msr    ttbr1_el1, x0
 12baa88:    d53da200     mrs    x0, mair_el12
 12baa8c:    d518a200     msr    mair_el1, x0
 12baa90:    d5380761     mrs    x1, s3_0_c0_c7_3
 12baa94:    d3400c21     ubfx    x1, x1, #0, #4
 12baa98:    b4000141     cbz    x1, 0x12baac0
 12baa9c:    d53d2060     mrs    x0, s3_5_c2_c0_3


>> As for QEMU, it is having issues enabling _EL2 feature although EL2
>> is supported by checking KVM_CAP_ARM_EL2; need yet to debug this.
> The capability number changes at each release. Make sure you resync
> your includes.

Been there but it seems a different problem this time.

Thank you

Miguel

> 	M.
>

