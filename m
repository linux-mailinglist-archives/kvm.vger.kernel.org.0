Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8775B780DBB
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 16:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377656AbjHRONF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 10:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377664AbjHRONB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 10:13:01 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED45170E;
        Fri, 18 Aug 2023 07:12:57 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37IC9625025678;
        Fri, 18 Aug 2023 14:12:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=ZPMioYLiLdjb9C9Hq1ER4VdqG8Uxhn1aaKMvj7UMxng=;
 b=VvSrnE4KciyaEGtAWc3zLXOtTjx0TNWPedcxmyrOkzQjW4xwvUy7u3HtqfY/QU7xlid7
 q5jtBCRFNHg6Gemd4RjfqZvlfZXUzfvYpAORT3IhjeQtIsyyYxc61sS0Bg/DXG1/KaGU
 V/6cHzE+sPdQQxhgGoFnqwlugkV+3InWfTE5wBIyO08Ym2mUqLgXLUNpvA9idkXCeSry
 Y1jEBAuTrJUf53QqhWR9KTxIeVLMiUIyW6GHnQeZD8WNWUO375RDpU7blIYVtYR0L2Zt
 rsiRkasNqmo0luux7hulcB7aMm5uMUycadKzaj7TvFAx7S1WWsr/AqLPWSD0Z6C2yELw PQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3se349m01h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Aug 2023 14:12:55 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37ICE0WO005488;
        Fri, 18 Aug 2023 14:12:55 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sey2h7dhu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Aug 2023 14:12:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gyj8RpTmZEmBvwioATcf9q6TQp6jtOJLgOLNMK0RqAm/ljpq+HIYIdSdnx8zHr6wWAAxzewju3LNxO6dpFCVxD+1a9TfiDzuqBJBubJonKkPoV/mrIH7yIIrTb7LnqJUp5friKSHFcGeqgLweTj9ivBGDVRsIWyPN8zhSIfnQBt5wXdUS8tANx4/bq0nfWMWQfSLZsPmiHgEXjw5f0/eRwroxYMGXTAODrRHJmEG2JchRXGv1WbxABhbMkzy8VDvryg0lRYU8CyPQZXLEu9VpQpnrsPA9owP4tP+i/sK+1WKKUstIJSE7X3LIoou8+g8BWgwf5vd+SK7ZB4HU5ihHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZPMioYLiLdjb9C9Hq1ER4VdqG8Uxhn1aaKMvj7UMxng=;
 b=XecDB2p9lLUP9o/IAPI5c1ZBdKrGVDcq5fLUBeMbDzWp0hebJHOV1hga4ObbKEzypZbX/gq0vUL3unpN51reB6YufcDo45qYe/Xr0krmBGSKEmXayivweG+SpDpdYZuh63TybrSWRTwyDY1rownkhjSGWCPMGdi5mDtuWa7cKcNr/ivF0IezMy0uRJLTxKPdXkU6+a/LEub5CpKs6B0pd2w/akfbGiuO4JqeNW/rrHOX+IRu1oHN7ynIXybi/cHxlkBZ9KUelTGDvflKXsHT0zCobhIBoUcggEKdbYSdh5UdzV+C+/rRHIqZLfLnLLwrEGomKXCxmDL/87veXuH/HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZPMioYLiLdjb9C9Hq1ER4VdqG8Uxhn1aaKMvj7UMxng=;
 b=oDJxUMQN7fi4lnN/nojJtrUj0odXDZ9xEynNs2mGCj2hRTOw5wXnW5BOyyXnPX4uzE6vC3VeGhGMfgpqGAelWeXfeCD/iv488nZz1K3P3PuAV19cmUMA3zTAOY+i4od/RIogfhzkLFZDtWBSqtm/fJBfFvv+e5c6Ao3fnRRaixw=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by CH0PR10MB5228.namprd10.prod.outlook.com (2603:10b6:610:db::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.20; Fri, 18 Aug
 2023 14:12:52 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::2990:c166:9436:40e]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::2990:c166:9436:40e%6]) with mapi id 15.20.6699.020; Fri, 18 Aug 2023
 14:12:52 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
CC:     Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: Commit 'sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather then
 sendpage' broke O_DIRECT over NFS
Thread-Topic: Commit 'sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather then
 sendpage' broke O_DIRECT over NFS
Thread-Index: AQHZ0SMM7jGcAll+1kuqtwDJI+Lc8q/upMaAgAAAK4CAAFF7gIABI2eA
Date:   Fri, 18 Aug 2023 14:12:52 +0000
Message-ID: <0F6CF5BC-B616-4931-B3C9-08A5691DD822@oracle.com>
References: <2d47431decaaf4bba0023c91ef0d7fd51b84333b.camel@redhat.com>
 <4DB1C27A-1B89-468A-9103-80DEDBF1A091@oracle.com>
 <617E47EE-77B4-4904-A32B-56F3E50895CA@oracle.com>
 <4a927976cba33e07a765d38ba6291d2d3f55254b.camel@redhat.com>
In-Reply-To: <4a927976cba33e07a765d38ba6291d2d3f55254b.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.700.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|CH0PR10MB5228:EE_
x-ms-office365-filtering-correlation-id: 7b60a4ea-b208-4c34-9719-08db9ff5362d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oFPVOh79Dt7jZNjfKoRjDeLbFP+nKq/VcxM1QHOGmkDMkDlfCOfqgpjBcV0VXuFQNflsyNnZfrIky/BI0JX7eXMVcG8YwOCbxyyZUfdMelCre0JOSk9q6eV5BQEtQy3jbOknNpofM7gMc6pHm1p96/qF7vvszZUSMo16q7hmljO1b9tdGJ+7Gov5f3AQt2McfN/d/z/zVc/+9cHmdnm6Fv/1oDzNbNsn7J772r7hLhitwga5MrAbAxr+yVhWBq24L4MBT9bP4uw0yx4xKt83ntzW8TS/ehJydkDOBkWqPnQyOkHcfI+v56peUpp/C+mnZbU2QFeHXkkvo4dkNTTi2byStbasW+xW53iVj8uZ9Ml7CMW2zwOqvKcDPygEaHW2xZGIW9wQoMxN1RzLXSSLDbyrLJmoTOwYQLJny4GfxuHwfnaBjFM01rbEZKUZ/JbtbZwU+s9Hg6YTmqGJb5IWUW5W4yP5HejgvzQKL2JFPMWiJ7lL43IaVX5nVudliatKmkCV+OpkW60CUNoEp1CYPEvy1XceoMkqme3oJwDggJOhJ0ZpKtMcG2p/v6XxrjY+woUSRluHiQR3z9tGK575US2UoJEJ3pg2V2f7P1NPqbY4c3ocahVD83dLF79PCVTluBEC04UUyVY3+PPV+CRFgS56o4gZlsS1TaSUFVaiCGQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(366004)(376002)(396003)(186009)(1800799009)(451199024)(6486002)(71200400001)(6506007)(38070700005)(38100700002)(6512007)(122000001)(53546011)(86362001)(26005)(83380400001)(36756003)(2616005)(33656002)(2906002)(54906003)(64756008)(66946007)(66476007)(66446008)(66556008)(316002)(6916009)(41300700001)(91956017)(76116006)(5660300002)(8676002)(4326008)(8936002)(478600001)(966005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Sk1rcnp3THk2bFVyRnptbDZYL1AxSHJuNEVnM0R2dC9sN3hFRHF3Um4rSG9m?=
 =?utf-8?B?NWZJaGN0czV5M25Ndnl0RVd6WEExVE1JYUxncGNkc01NTGlyb1VLUFdLUHNN?=
 =?utf-8?B?T0tXTGNSL1ZiWVVmT0YzZkQ2ZlRET3BnT3BnMGRsdWM5NmN4VjhhMUorVEpY?=
 =?utf-8?B?ZU5hOWY4MWRjR3BoeTlINUhHNm9uRU12Z045blRMOXFiSHdFOHRTOGFua0R0?=
 =?utf-8?B?VFVTODBsVllZZlBsL0tCNEkrb3FlM3ZvSGY4c1N4bkRDbWdIVFlqelhhSTNy?=
 =?utf-8?B?Zlg2M1hLWnNMcFlqZjluZSsyUG5hRElsU1FLWjZ5VzN6STRSNm83Vm1XQlpY?=
 =?utf-8?B?MkdVVlp2bnpJanlwMVNDTlo4UERiT3ZEN1d4bmt2L2lJQ0pvTkhUeUhLUGgw?=
 =?utf-8?B?VmNRbWt5RGhtYkx6ZmVkcmZ2cWdBdzJjamJicVVmUHpKWVJYa0NNd0dsS0hm?=
 =?utf-8?B?RzFvaUVudW4xRkl1YWQ4WDlrS2lnOGJJd0VkUjBQWmUwUHdaYmNwN2V0eEcr?=
 =?utf-8?B?Z0VMdWd2djh0dDU2OS9hWkRkVEtUZHhmckFOWndUNlVQVjljSUJ5bjkxakRR?=
 =?utf-8?B?N3NWS09UQWw5aVdGNlhIekx1aDR0Tzh6QXBMSGFSSzk2V2I4SUxTRkZaY1lj?=
 =?utf-8?B?RWtxZjdpU3BsNldaQnh6djhlZ2IwY21xK0MxRFN3MkJ2enp6V0NxMmQ0Z3V1?=
 =?utf-8?B?RUhZKzJSU0s4ZnF5YmJLdTJqTnB1b0UxdU9EZVVydzRQL1VCaTZTMWM0K3JP?=
 =?utf-8?B?TGJDb09uN2d3S3RoTmUreTdwOGVZakdxUWd2bWczeXBEa3YzRGNRNW80UktQ?=
 =?utf-8?B?amJzcHF0TE41cHAxWFFselBCazQwekRNNVNNV0RNRElQd3BRWXd3bDVNYVNh?=
 =?utf-8?B?QUNsUW5BTGxRVndjUjAzcGp2OC85ZytMMlpKbk5VaUJ2R1J2UG9Ma1lXaEF0?=
 =?utf-8?B?ZkcwcWdkVEVBK2lIdFk3NjNBSzh2VHpGSjN4eFhtMUQ0cjJIL3pSKzdEZWlr?=
 =?utf-8?B?TGpIV09IbWpVTENUWGsyeEU5OTFzS0I5TWlpRXVKOWdjLzIvQis1bHo3dDhu?=
 =?utf-8?B?anBiemkxWXB3bG1Rb3FDRDV1Qkgxb0lRYncvNG9FTlZQcllvWmRqdks3YXVZ?=
 =?utf-8?B?VEQ0V0JGTjJOWUsxVC8zcVZ2NmZiTEJnS0J2LzNzWkIzbGt4bXNxWTF0OElG?=
 =?utf-8?B?b3pVaXdEdm5pcHpHSW5haEFzL1NNUnJLWWorbXQ5RFYzMFZHakFqdTVTeHlJ?=
 =?utf-8?B?Y0l5MWFCMmxEcFd6Sm8rbDF3U01BZWdYK09UZTJTL0d6SE80RzV3bnJtODVz?=
 =?utf-8?B?Y0xYRkUrc2d1dk5yVnVna3RQdS9WSDRnck5FMWZiS2RsVmVnWWZMUC81WVMz?=
 =?utf-8?B?dUIwRU5oTGx5K2hxZG9oY015alNZa3VBZVVrSUZqbVdTUnZVd2RCZ21ybjZt?=
 =?utf-8?B?d3VBVmNFQUs1MExKSkxXOEpic2JlSTlRdnVEdHcwUTZsUFNCOTBPcnM5SHNk?=
 =?utf-8?B?Y3NrcVI1RXVQNVJrYzRONjU2YXR2dmZKNks5Y2R4cVo5VGtGYU1EaTh2azBu?=
 =?utf-8?B?Qmpjd3Qvb1p0RytBeUJMWUdTeEErODJ6OHpPSENMOHZnUi9BdlFjMFN1MUIw?=
 =?utf-8?B?U3FyejJzRmZEM1NkbEMxRjdLZTRGMmNoZ0JOVnl0YUV4NjBqVDQ5anMrNXBy?=
 =?utf-8?B?QXA4UVE0QWw4UTkzZFlOcDZpb3Bic2lvN3VGNThjRGxhMkRqYnBXL0FtOXBl?=
 =?utf-8?B?WVNUV0VIK21HUll6dzdRTVZzbFNmQ1FJVnV0TDNwNllaYXR0VTNkbHpnbWxP?=
 =?utf-8?B?L2NERkRtWXpVTVBKS09BQTgxVEEwaWtYL2pVN21SeFRDR1dtaGNiVFl6VjVM?=
 =?utf-8?B?cUNvN2p3TGtWV1F5cW5DMXRudCtGek9uVERjK2RBMUNjMUM0S25WRmtQVmlj?=
 =?utf-8?B?M2dRUW5YMmxPVmhxWWlqYmdCSzBxSHJoQzV3OWlqU2ZPS1RpZmluN3hOd0tM?=
 =?utf-8?B?RTBzSmg0QVdwL0ZYVER6dUU3RkZYSTZWWU1MSmhUWVBsQjF2MHIvUUZrV3Fs?=
 =?utf-8?B?aVNLWmI5NG1VWlZ1aXB4K3J5Tk9lM2hTeG15MkZxb003OWpUQ25pNE96U2F0?=
 =?utf-8?B?VFNkcHllYzdwQ1JuandZTUdyNlBSSHUzak1aSU00c3QzaFNkODBnU0hlRm1j?=
 =?utf-8?B?a2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E84F988A80FCBE45B7F832C083AD32D8@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 2kuPX1G3NrN7kRoyJCMtR2NclDhKZr0eDpynw26IEGfaxBeVBz9dFHsdmg7b2HQ8w4b2HqlOuhYdxQk+XsVtIjLHME+sS5EnRFio7mJnS52Oi3zRcm/dOk/or9w02XG1zdtxLvqowYDfa1q3v8wsy7+s9QDtfUudH4OlTTQJian//mE/+N22S26Q07MJabwTNqyVlYD3a0CoWOqriaYryK08bTgSexJDGqEaYeKdsqK4Dbl9w+LlaTNuzy3akvM/y9uR6y8y3ywnMI/M6Doqt0ckIGeHUbHMLxIJsUapqWiHhwqRnChZ1LCrrcVJDBq1q8ZvJpsfZV5ZUItQmGxZAdLfyOqPhALOg0SE90jRqksSJaG2FisSFKGBa3X5lMWXCUcjYutbAsNsjoBdV/wP33Q4JKF8bDZYhfGrtg1gWGwZnIuTglfQciDEhqcuHf5eK4JLCraYXImazcRndXQz7pg/emgEDaOBIHrjdoy1OCQVOWrxDEBo+XckzHsuUGiQ9CcqivnlCPf9jemllIMdrVBiJfCrEiM1zIPaMUFXZbWa17u42r4wbERDGavHrJ4YyyFkU2QntbjzMh5uMfdNsBeS2fZmgeQfR/fn/+TEAkDp7sxWH2Mz7ilwPj5U1nEhSkKVgj3EfN5GiCpTRkZVQ17IOI9wYTRhSC6rL4ryrVxJ8pRbiE2kUFXHfbxUIwFk2Zm/9y4qH8ja3jfHmfMPXtIzfKeSC5jz0uCt4QhRFeuKyCnnSkYUGb2vQ/K9MMvweZWD82jmEVHi8HkZVGwYfL3VnKApZr3JFNX+3M8PUxI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b60a4ea-b208-4c34-9719-08db9ff5362d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2023 14:12:52.7728
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0bTYyE2Nn2G/zAuNAq7U+4VCFWerqumkqNmf4ET+zrIP96lUHR4PnXL2xnmAMbEOjOXOPrhP7Ii9rPLesrt7fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5228
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-18_17,2023-08-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308180129
X-Proofpoint-GUID: MUQOKQpEvW3CDgtdSmkqTdERfq5asVnA
X-Proofpoint-ORIG-GUID: MUQOKQpEvW3CDgtdSmkqTdERfq5asVnA
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gQXVnIDE3LCAyMDIzLCBhdCA0OjQ5IFBNLCBNYXhpbSBMZXZpdHNreSA8bWxldml0
c2tAcmVkaGF0LmNvbT4gd3JvdGU6DQo+IA0KPiDQoyDRh9GCLCAyMDIzLTA4LTE3INGDIDE1OjU4
ICswMDAwLCBDaHVjayBMZXZlciBJSUkg0L/QuNGI0LU6DQo+Pj4gT24gQXVnIDE3LCAyMDIzLCBh
dCAxMTo1NyBBTSwgQ2h1Y2sgTGV2ZXIgPGNodWNrLmxldmVyQG9yYWNsZS5jb20+IHdyb3RlOg0K
Pj4+IA0KPj4+IA0KPj4+IA0KPj4+PiBPbiBBdWcgMTcsIDIwMjMsIGF0IDExOjUyIEFNLCBNYXhp
bSBMZXZpdHNreSA8bWxldml0c2tAcmVkaGF0LmNvbT4gd3JvdGU6DQo+Pj4+IA0KPj4+PiBIaSEN
Cj4+Pj4gDQo+Pj4+IEkganVzdCB1cGRhdGVkIG15IGRldmVsb3BlbWVudCBzeXN0ZW1zIHRvIDYu
NS1yYzYgKGZyb20gNi40KSBhbmQgbm93IEkgY2FuJ3Qgc3RhcnQgYSBWTSANCj4+Pj4gd2l0aCBh
IGRpc2sgd2hpY2ggaXMgbW91bnRlZCBvdmVyIHRoZSBORlMuDQo+Pj4+IA0KPj4+PiBUaGUgVk0g
aGFzIHR3byBxY293MiBmaWxlcywgb25lIGRlcGVuZHMgb24gYW5vdGhlciBhbmQgcWVtdSBvcGVu
cyBib3RoLg0KPj4+PiANCj4+Pj4gVGhpcyBpcyB0aGUgY29tbWFuZCBsaW5lIG9mIHFlbXU6DQo+
Pj4+IA0KPj4+PiAtZHJpdmUgaWY9bm9uZSxpZD1vc19pbWFnZSxmaWxlPS4vZGlza19zMS5xY293
MixhaW89bmF0aXZlLGRpc2NhcmQ9dW5tYXAsY2FjaGU9bm9uZQ0KPj4+PiANCj4+Pj4gVGhlIGRp
c2tfczEucWNvdzIgZGVwZW5kcyBvbiBkaXNrX3MwLnFjb3cyDQo+Pj4+IA0KPj4+PiBIb3dldmVy
IHRoaXMgaXMgd2hhdCBJIGdldDoNCj4+Pj4gDQo+Pj4+IHFlbXUtc3lzdGVtLXg4Nl82NDogLWRy
aXZlIGlmPW5vbmUsaWQ9b3NfaW1hZ2UsZmlsZT0uL2Rpc2tfczEucWNvdzIsYWlvPW5hdGl2ZSxk
aXNjYXJkPXVubWFwLGNhY2hlPW5vbmU6IENvdWxkIG5vdCBvcGVuIGJhY2tpbmcgZmlsZTogQ291
bGQgbm90IG9wZW4gJy4vUUZJPyc6IE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkNCj4+Pj4gDQo+
Pj4+ICdRRkk/JyBpcyBxY293MiBmaWxlIHNpZ25hdHVyZSwgd2hpY2ggc2lnbmFscyB0aGF0IHRo
ZXJlIG1pZ2h0IGJlIHNvbWUgbmFzdHkgY29ycnVwdGlvbiBoYXBwZW5pbmcuDQo+Pj4+IA0KPj4+
PiBUaGUgcHJvZ3JhbSB3YXMgc3VwcG9zZWQgdG8gcmVhZCBhIGZpZWxkIGluc2lkZSB0aGUgZGlz
a19zMS5xY293MiBmaWxlIHdoaWNoIHNob3VsZCByZWFkICdkaXNrX3MwLnFjb3cyJyANCj4+Pj4g
YnV0IGluc3RlYWQgaXQgc2VlbXMgdG8gcmVhZCB0aGUgZmlyc3QgNCBieXRlcyBvZiB0aGUgZmls
ZS4NCj4+Pj4gDQo+Pj4+IA0KPj4+PiBCaXNlY3QgbGVhZHMgdG8gdGhlIGFib3ZlIGNvbW1pdC4g
UmV2ZXJ0aW5nIGl0IHdhcyBub3QgcG9zc2libGUgZHVlIHRvIG1hbnkgY2hhbmdlcy4NCj4+Pj4g
DQo+Pj4+IEJvdGggdGhlIGNsaWVudCBhbmQgdGhlIHNlcnZlciB3ZXJlIHRlc3RlZCB3aXRoIHRo
ZSA2LjUtcmM2IGtlcm5lbCwgYnV0IG9uY2UgcmVib290aW5nIHRoZSBzZXJ2ZXIgaW50bw0KPj4+
PiB0aGUgNi40LCB0aGUgYnVnIGRpc2FwcGVhcmVkLCB0aHVzIEkgZGlkIGEgYmlzZWN0IG9uIHRo
ZSBzZXJ2ZXIuDQo+Pj4+IA0KPj4+PiBXaGVuIEkgdGVzdGVkIGEgdmVyc2lvbiBiZWZvcmUgdGhl
IG9mZmVuZGluZyBjb21taXQgb24gdGhlIHNlcnZlciwgdGhlIDYuNS1yYzYgY2xpZW50IHdhcyBh
YmxlIHRvIHdvcmsgd2l0aCBpdCwNCj4+Pj4gd2hpY2ggaW5jcmVhc2VzIHRoZSBjaGFuY2VzIHRo
YXQgdGhlIGJ1ZyBpcyBpbiBuZnNkLg0KPj4+PiANCj4+Pj4gU3dpdGNoaW5nIHFlbXUgdG8gdXNl
IHdyaXRlIGJhY2sgcGFnaW5nIGFsc28gaGVscHMgKGFpbz10aHJlYWRzLGRpc2NhcmQ9dW5tYXAs
Y2FjaGU9d3JpdGViYWNrKQ0KPj4+PiBUaGUgY2xpZW50IGFuZCB0aGUgc2VydmVyIChib3RoIDYu
NS1yYzYpIHdvcmsgd2l0aCB0aGlzIGNvbmZpZ3VyYXRpb24uDQo+Pj4+IA0KPj4+PiBSdW5uaW5n
IHRoZSBWTSBvbiB0aGUgc2FtZSBtYWNoaW5lIChhbHNvIDYuNS1yYzYpIHdoZXJlIHRoZSBWTSBk
aXNrIGlzIGxvY2F0ZWQgKHRodXMgYXZvaWRpbmcgTkZTKSB3b3JrcyBhcyB3ZWxsLg0KPj4+PiAN
Cj4+Pj4gSSB0ZXN0ZWQgc2V2ZXJhbCBWTXMgdGhhdCBJIGhhdmUsIGFsbCBhcmUgYWZmZWN0ZWQg
aW4gdGhlIHNhbWUgd2F5Lg0KPj4+PiANCj4+Pj4gSSBydW4gc29tZXdoYXQgb3V0ZGF0ZWQgcWVt
dSwgYnV0IHJ1bm5pbmcgdGhlIGxhdGVzdCBxZW11IGRvZXNuJ3QgbWFrZSBhIGRpZmZlcmVuY2Uu
DQo+Pj4+IA0KPj4+PiBJIHVzZSBuZnM0Lg0KPj4+PiANCj4+Pj4gSSBjYW4gdGVzdCBwYXRjaGVz
IGFuZCBwcm92aWRlIG1vcmUgaW5mbyBpZiBuZWVkZWQuDQo+Pj4gDQo+Pj4gTGludXMganVzdCBt
ZXJnZWQgYSBwb3NzaWJsZSBmaXggZm9yIHRoaXMgaXNzdWUuIFNlZToNCj4+PiANCj4+PiBodHRw
czovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90b3J2YWxkcy9saW51
eC5naXQvIG1hc3Rlcg0KPj4gDQo+PiBJbiBwYXJ0aWN1bGFyOg0KPj4gDQo+PiBodHRwczovL2dp
dC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90b3J2YWxkcy9saW51eC5naXQv
Y29tbWl0Lz9pZD1jOTZlMmE2OTVlMDBiY2E1NDg3ODI0ZDg0Yjg1YWFiNmFhMmMxODkxDQo+IA0K
PiBJIGp1c3QgdGVzdGVkIGl0LiBJdCBkb2VzIGhlbHAgKHFlbXUgZG9lc24ndCBjcmFzaCBhbnlt
b3JlKSBidXQgaXQgZG9lc24ndCBlbGltaW5hdGUgdGhlIGlzc3VlIChWTSBzdGlsbCBkb2Vzbid0
IGJvb3QpDQo+IA0KPiBUaGUgVk0gbm93IHN0YXJ0cyBidXQgaXQgZHJvcHMgaW50byB0aGUgVUVG
SSBzaGVsbC4NCj4gDQo+IE9uY2UgYWdhaW4sIGRpc2FibGluZyBPX0RJUkVDVCBoZWxwcyAodGhh
dCBpcyAtYWlvPXRocmVhZHMsY2FjaGU9d3JpdGViYWNrKQ0KPiANCj4gRm9yIHRoZSByZWZlcmVu
Y2UsIGZldyBrZXJuZWxzIGFnbywgSSBoYWQgYW4gdW5yZWxhdGVkIGJ1ZyAobm90IGV2ZW4gTkZT
IHJlbGF0ZWQsIGl0IHdhcyBoYXBwZW5pbmcgbG9jYWxseSBhcyB3ZWxsKSwNCj4gd2hpY2ggY2F1
c2VkIHRoZSBleGFjdCBzYW1lIGRyb3AgdG8gdGhlIFVFRkkgc2hlbGwgd2hlbiB1c2luZyBPX0RJ
UkVDVDoNCj4gDQo+IGh0dHBzOi8vd3d3Lm1haWwtYXJjaGl2ZS5jb20vcWVtdS1kZXZlbEBub25n
bnUub3JnL21zZzkxMjU0OS5odG1sDQo+IA0KPiBJdCB3YXMgZGVjaWRlZCB0aGF0IHRoaXMgaXNz
dWUgaXMgYSBxZW11IGlzc3VlIGJlY2F1c2UgaXQgcmVsaWVkIG9uIHVuZGVmaW5lZCBrZXJuZWwg
YmVoYXZpb3Igd2hpY2ggaGFzIGNoYW5nZWQsDQo+IHNvIHRoZSBxZW11IGdvdCBwYXRjaGVkIHRv
IGZpeCB0aGUgaXNzdWUgb24gaXRzIHNpZGUuDQo+IA0KPiBTaW5jZSBzb21ldGltZXMgSSB1c2Ug
YW4gb2xkZXIgcWVtdSB2ZXJzaW9uLCBJIGhhZCB0aGlzIGtlcm5lbCBjb21taXQgcmV2ZXJ0ZWQg
Zm9yIG5vdywgYnV0IHRvIGJlIHN1cmUgSSBub3cgaGFkIGJ1aWx0IGEga2VybmVsDQo+IHdpdGhv
dXQgdGhlIHJldmVydCBvbiBib3RoIHNlcnZlciBhbmQgdGhlIGNsaWVudCwgYW5kIHRlc3RlZCB3
aXRoIHRoZSBsYXRlc3QgcWVtdSB3aGljaCBoYXMgdGhlIGZpeCBmb3IgdGhlIGJ1Zy4NCj4gDQo+
IEkgZG9uJ3QgcmVtZW1iZXIgZGV0YWlscyBvZiB0aGlzIHVucmVsYXRlZCBidWcsIGJ1dCBpZiBJ
IHJlbWVtYmVyIGNvcnJlY3RseSwgcWVtdSBoYWQgdHJvdWJsZSByZWFkaW5nIGZpcnN0IDUxMiBi
eXRlcyBvZiB0aGUgdmlydHVhbCBkaXNrLCB3aGVuDQo+IHRoZSBWTSB0cmllZCB0byBkbyBzbyB0
byByZWFkIHRoZSBib290IHNlY3Rvci4NCg0KTGV0J3Mgc3RhcnQgd2l0aCB0aGlzIChvbiB0aGUg
TkZTIHNlcnZlciB3aXRoIGM5NmUyYTY5NWUwMCBhcHBsaWVkKToNCg0KIyB0cmFjZS1jbWQgcmVj
b3JkIC1lIHN1bnJwYzpzdmNfeGRyXCogLWUgc3VucnBjOnN2Y3NvY2tcKiAtZSBuZnNkOm5mc2Rf
cmVhZFwqDQoNCmFuZCBydW4geW91ciBmYWlsaW5nIGRpc2sgYWNjZXNzZXMuIF5DIHRoZSAidHJh
Y2UtY21kIHJlY29yZCIgd2hlbiB0aGUNCnJlcHJvZHVjZXIgZmluaXNoZXMsIGFuZCBzZW5kIG1l
IHRoZSB0cmFjZS5kYXQgZmlsZSBpbiBwcml2YXRlIGVtYWlsLg0KDQoNCi0tDQpDaHVjayBMZXZl
cg0KDQoNCg==
