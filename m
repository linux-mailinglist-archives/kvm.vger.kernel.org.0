Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE9F6CBC6B
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 12:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbjC1KUh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 06:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbjC1KUf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 06:20:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22AE04EE8
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 03:20:32 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32SAJf5i029268;
        Tue, 28 Mar 2023 10:20:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=/snZnygvI/n23ZTtfW77pYq61vzyG6vJA9SK0x1emI0=;
 b=yFVdwJvgfGnq4OlG6C63KbzMvNibe+eopD3wzxyXge+UdgspGD5uxbphW5xkj7hAQeOb
 AYJRoWCEv0t/VxcU76ee4nrdmSZsq5FEYEBYWfbHzKBCGBbNq0vwLhEfft3xL3NOedFn
 2uKmmYrv7j9BhzwPa/ci0yOwOMBDhkXErcrAaT6VS9cg2bi0WKaFsuKKDt+NiVcU0b3/
 NHaIQFZUKzhQihzrl6zsBBj5guYia/HTem8sqCiWGNkJyPYHrdfo86+QN4x/NKylgF5W
 YQtP3W6kNePXQ0G78Gp9988k+HlM8HC6+EuEI13na+liZ4gAX9lfvHW5faUQxXnhY0Wm AA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pkxcp8010-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Mar 2023 10:20:11 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32S9ecSb026756;
        Tue, 28 Mar 2023 10:20:11 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3phqdcqntu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Mar 2023 10:20:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M2cIv+C6ori4pqfgFhD3Ti5lCgUovhmq79pskIqJr7DUFWdVdCjKSbeycSU07PWX463FMs1HNqMDEBoSsPyVYxPUnLMdEa7qRTlmNgWx1YhgvPW6pWzgfyIgTubz5hYobpOZC+m9gVrfKK9xeG6GL6U2yBsnhKUGuCdpZ8lGHSEQw5FFNPBqItUcqmCSZ64z8q+D/oeerw3OduisoEAfU22zIWKnHUK8cxkoHhjM8z0FGD//oQ/BAnwWJGdCVjj4vr5FQd1aADuiEO2HfPEFp389e8SOgq1y7mYQFzV0lO5UglSOAdbqMnpD5kRQL5CH0SnKA6G4MMCrA4FSMyllPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/snZnygvI/n23ZTtfW77pYq61vzyG6vJA9SK0x1emI0=;
 b=jdD+AXSmazbgOaTMKNGc+G8yQSs7SHK9wUxgDqsZl51UyUYFMU1t7ODDBpyLEAjL21u0ZXOJ+BIzM6r6ZVMGvH+la3bc2WSD/w6oqAF/t10k+UDwxAOYdsEQCmNlVwZ7dY5iu4Ygqzax3JhGq4XrBbHJCNEkXNux3AF/HntGRY3soTmVwdinN62vzOd6dyYzjvr4T+g5NCw8zP9hg1MKjMY0N9g4ScGhUENKt7K3wHyZUH7WqLee6942FxY2Li7de1/R1iLQZKQG9vQlwMiF6TmTPbP48OVzraDBOF4N6wKFRvFSK6QxqoGCayZh4H739l2HBb+OHXrqXlNCPxzbpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/snZnygvI/n23ZTtfW77pYq61vzyG6vJA9SK0x1emI0=;
 b=vtVUk4fsoH8+ZBlt2rWJj4FRZKrxTm55D9MsjUwTIm2Fp1CPK1KZA9ktkYIA/7vFWn1CrQIVQaIa0vnxlPabbixlFAUvoG4ZuTNFDQH3sfNCXa9Np2TyeavMTSNEk4R2RVP9jnrfzX0Te/V9FtQgeFnfvMrAIPWeeVDESQJY/jk=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN0PR10MB5936.namprd10.prod.outlook.com (2603:10b6:208:3cc::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Tue, 28 Mar
 2023 10:20:04 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::cd4:d27c:94b5:e2da]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::cd4:d27c:94b5:e2da%4]) with mapi id 15.20.6222.033; Tue, 28 Mar 2023
 10:20:04 +0000
Message-ID: <ab4d6a88-5003-c04a-1b7c-7356e5377f4e@oracle.com>
Date:   Tue, 28 Mar 2023 11:19:57 +0100
Subject: Re: [PATCH v2 1/2] iommu/amd: Don't block updates to GATag if guest
 mode is on
Content-Language: en-US
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vasant Hegde <vasant.hegde@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        kvm@vger.kernel.org, iommu@lists.linux.dev
References: <20230316200219.42673-1-joao.m.martins@oracle.com>
 <20230316200219.42673-2-joao.m.martins@oracle.com>
 <63e71a7c-3767-dd00-7744-8a12663ad814@amd.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <63e71a7c-3767-dd00-7744-8a12663ad814@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P192CA0029.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::14) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|MN0PR10MB5936:EE_
X-MS-Office365-Filtering-Correlation-Id: 19f0ef99-bf94-4c61-f1a4-08db2f75ff2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kcJPAphAxk3yfkhj7JIgELSrMMpoUSfydn6Dd+iujvjCh4V5va7xiR7yEAxW5q59ffHbCdrWykDL0vympW/TqYnF1zxMIMrD9yuv7DyvLzgMjldjeGGJOLLRgWGDMrl9KlA8BFPh/5fyPY+O2hJ14L87S2q+nsvRZveHQec599x8ASZa18P3E/3PqoB/ZxHa0+P7tGJQn24awPxEPqLT9WMtTrPZMl5EbHjaD+cb8F/BeNE2Akl8sjr8QIJvjhbSVktnZTokxM1dHNxchLCS/UgNot4VYK3ItVLOhhmNZaJYwE/r9HhDvFFh2F/hD6dLcNyyeBAO8IPBFqH0xTWAqfsk/1FPOkX/WIlngPJ8X8OpRkJjp0DAFnkuDmX6hwAiY1acB7R1S6gx1BrgNp+FVd2R2Hp7eScMoOfnD3VG1f/zj8ThduFvAhPqpS5l8pYwCU8h9QWMkTmkuuiHMVz6rYHL+801KQ2SmcUk0LnK2fRFEzirPo6TJUD3eZ/h9+Lwh8416dUJMYDvUnEFTcbabK4SYRJcaHlhnO07LG3E+DvoDIVqOZGyuiOunZFEqNJgB4ngt/QgaUz9QIouUlpxBtJTRAHxx+OYT2PFpJZ1qUbOq8YUU8EnEYs2Z7pfmf0J
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(39860400002)(376002)(366004)(346002)(451199021)(6666004)(26005)(6506007)(6512007)(53546011)(6486002)(6916009)(31686004)(54906003)(316002)(478600001)(186003)(83380400001)(66556008)(66476007)(8676002)(66946007)(2616005)(41300700001)(8936002)(4326008)(5660300002)(15650500001)(2906002)(38100700002)(86362001)(31696002)(36756003)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Uzk2ZTBCaDlVdjNxQlVYdDJ3ZFVlR3hOMThia2JHSVk1TitHSUN5cGpUNVpS?=
 =?utf-8?B?SDZyY08raHk2K28zQUd5cVdBL2JvRjBJSFpxQUVwdVMvK050M1dQTm1TcmlG?=
 =?utf-8?B?RUdidkhmS3Jka0RnVkd4K1BaN1Nma0cyRFJGYjNHT08ybjY5KzJRTzBHRzBF?=
 =?utf-8?B?M3hRSzFyQitjTFgvbUtyZVMwaXp5WmZPMDcxTzZaQkdWblEraWhpc3RablE1?=
 =?utf-8?B?ZHAzOXpaT0hoYjltNllqaDd6SXNSWHd5SjNpSnRCOU9mR0hQNVA1WnNmMStD?=
 =?utf-8?B?R2l5bWxkVll6L2REYlFwc3JhYzVUTjNNNWk3QjlKSmEzaGRNTmRCY0ZpNWQ2?=
 =?utf-8?B?Y1JCQUtLK2RsT2xldmM3aGVwVTZ1NnlveUVSQ0Z3YlpoMDdESFNmQTZLZEtT?=
 =?utf-8?B?TFRxeW1nUDNYdzZrNFU0MThhQk1YOXoyYmhhbnlnK2NSYytITDFJWll4WXpX?=
 =?utf-8?B?cE9ueDRSTFk0WU1xdEQ4Z0h1NFozVUI2Umd6dGtsUjF3Z2tWZjhVUDVXUGw4?=
 =?utf-8?B?cXpBYktlc3dkdnlTMnprOG9PT2RSTjdkZDVaQ2w3bnBtQy9NcUpOdktZaEZY?=
 =?utf-8?B?WnBQVVYyOWVZQlp5MFk3TkFrMGF2MzVRdHVOWFdXeFJIK2Vya2dqU1lIQU5U?=
 =?utf-8?B?NVdILzNIRDdhSnR6NkRQa3htVGlvblVUeDdoRVJZYnlTd2I0NG42cGFaYlNJ?=
 =?utf-8?B?TUdKYkNxa01GaHdyUTkvbmZEaDJtVTlsMmNtWWtBbUIvZFVRRmd6Y1VTdGoy?=
 =?utf-8?B?K2NXV0hLU0VPVkxqSTdtVGREMGF0VDl5U3FGYTMyNWdBL3IyQmNCMGpHcENQ?=
 =?utf-8?B?R2djcmordE1VOERuTVpadmZkYjZBWUpjL084c1lyUkRpeHdGL3BlSnRISFQ2?=
 =?utf-8?B?SllJb1NHK2U0b3g5QVZoc2p1Y2FaOFlyZ29rekttVkc3eEMwNlNDVHlFYU0w?=
 =?utf-8?B?b3lNa0ZuMGZ5SG9zNkJpcmV6eG9WVnhXR1lFdTlOc0loTnBvN2ZvNTZrWnBx?=
 =?utf-8?B?Y1RCeTJsQjRTd3ZMTlVyWU5KUng1ZW5ONW9yLzh0MDJ2RDN4Y2hUOThUQnRI?=
 =?utf-8?B?MFcxem8wN2RJbmthVkRmMnRXSEthMWpDYUJJd1IvQVY1Qk93ZjdzYjVHL1ht?=
 =?utf-8?B?NWo0cG1CZFJ4d2daSEJua0Q2akg0VVlZdHA5MGxNNVhNbUFYWHo5NWpIdXhG?=
 =?utf-8?B?WExmZVVIUWF6NVVkZWJiM3ZhZGVWS1djOGEwT0VCVVdEUUVDVmdsM2RGZi9v?=
 =?utf-8?B?STNGblM0Nk0yangzMXUzNW5nZmlsdkVBSG5Va2JkL2JiVlZtbWlUZkpFNkI5?=
 =?utf-8?B?U0dreEdpRkJ5WFh4Um9QdDF3U2dFUVNrSUpoMUdXOXIrZURkRFFieGlna0Js?=
 =?utf-8?B?T0E5bk0wSytGRGZOdCs3cGh1VVlyb0FPWHU4RzVxeDR1TDY5QUJ0VUp5M0dH?=
 =?utf-8?B?TjhIS0o4aVY5SUl1eWZsTThxOTdPWWxaM3M1SHp2MGc1WWVNM1lLZHgxQ3Az?=
 =?utf-8?B?RDc5SllkWlVlT1lyMjZVTkRCRFlvaFlONlN4bEFqWjhIelZzenorNUpENGZG?=
 =?utf-8?B?bzJ3WWhRK2NpRS9yblEvalVrVG9Ibnd6S2Z3TjNVOVFmUG5ubEVMYW1GWTBE?=
 =?utf-8?B?M0lGbEw5U2hqS1lSZGNnNUNheVAvaFIyUE0zVlVGKy8xbENvbkJVVG1VeWxC?=
 =?utf-8?B?VDBZclZjMTlUOHdqUGlvMGsrMEVLU2VOa2p2MlhLUGZvZ3loYTdSc1JBeTQ0?=
 =?utf-8?B?UmIrNm92Y3dBMVdka2M5ekVCbUhqT1ZDS2Z1NTlpR256WVhQMXFzTVkvSk4z?=
 =?utf-8?B?cFIrSlhGMlE2RXJYRUthVDRpejVZNkFKVHo4OWFiK1FpaGpTTUc0ckFnekYr?=
 =?utf-8?B?QktOMjNIejJJbFhOQytnR1NZQ2ltSlpSbXhuc0ZxUGx6KzlLb3RvK1B0MDhw?=
 =?utf-8?B?ZnpOcFpURDRFbnZRbXY4TkdWbTNQTjBPUnN3SWVETTVubFdsUktsL0hOQjI3?=
 =?utf-8?B?RkNna1NkaG5MdTZzSnRTTTBkVzUrVUhNYmFremJCT0hUNi9rVTBXdlJyUFNZ?=
 =?utf-8?B?akUzVFN3OWR4MGJsUG5LME9wMmFReHpGSkl3MkZrQ0U4ZzkxRi9rRjJDV05C?=
 =?utf-8?B?ZzJtWDd6U2tUTmQ0MWlvQ005ZEFZZlk3YUkwVVRzMmdCWk5jOUNBQks2cWdL?=
 =?utf-8?B?cnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?ZWdIZEI5N2VUVjNwb1AyaTBGZ0l4c3hrQitqM01FdjlXd3l6cVVsYkdWdjVz?=
 =?utf-8?B?YmxwdDJZUDdTSUtBTjJjdE9tVnhXeG45TXgxcWNxd2xjeHhtTkF4NE5kaEJP?=
 =?utf-8?B?ODZvVzZFY1pKdjVTc000OUtNNzJjNVJ2YUFWVk9sTnplZS9qczRWQ1R3bldU?=
 =?utf-8?B?TDEwZnFFRDQ0MzdQdkprTEZScDRZcHpmS3dZRi96VHhrS3BMTXc4MnROaVdt?=
 =?utf-8?B?aTRoUnZNSEpWN2JMTldsUkovUDljYWVGYVJFRFhvRmRzaFRPbTRCNlJTaERI?=
 =?utf-8?B?QTlXcVRjOHRDV2IwcW96NmFURXpsR0dDd1hmQzFVZjcrWkljakFDZnNjdFdx?=
 =?utf-8?B?am5IeHpKWWdaVTZkMTNKMGd5SlZDL3BiOHRLUHJXbHIzL0FoNktQLzRWN3RK?=
 =?utf-8?B?QlUzNjAxYTM4ZG9FUm1TVnBWTFUzN0FlSG1Kd3NyOVg2ZENvd1dUcVI2a1BN?=
 =?utf-8?B?RS9GMnpyYUROMktwKzdTeFpqWU1ZWndXZytyNW5kODRSaGFJTXZTa1ZHa0I1?=
 =?utf-8?B?NStFUjdIOGd1WXZIMGM3NlhYajcyTlE5SFUrTTdWYW56VHVzeXVmekRNWVQ1?=
 =?utf-8?B?TC9abVRNNXV4R1MrNjhOaFZxUE1qSEo1c3VrYWl0U25MM3FrVDlPSGxscHg5?=
 =?utf-8?B?TkVhV3pRcDVyRS9hY0xNODNqMitTcTFFWGZwTEI4U29yS3h0bk5YZTVScEl2?=
 =?utf-8?B?emVnQUZMMkNEWWliLzNtdmhIRitMaHNRYmc2aHA2S1p3RldsbUs0cjdQNlRr?=
 =?utf-8?B?SFRtcW4vOW43d3EzelcxOElZWE8ydTgzRnNMRUEyU3hGNjZNUGs1dDlxcFNN?=
 =?utf-8?B?dldzYWtFUWlBL2hUdmw1Qy9Iak5mc3JHWUpLeXJIeUlVSUlpb2had2htTEtz?=
 =?utf-8?B?YzVwQ3dxQXJ2U0laVUZQU3RWdGV4RW9Zc1MweENGTVJtYzJNNGJqcTRSdkhX?=
 =?utf-8?B?NVFBM0QvQ2tNWTVUL050N3VOL3lpL25Od2FkM1owbWJZRWg3eWJRdCtRVVZF?=
 =?utf-8?B?Z3NyTEpkMjZVc1NBdFN4a0JmUm5Mbmo3VVdkMlM1Qm55WlkwY3dvY1pqejU4?=
 =?utf-8?B?R1VsV0J2c2lZY0tMSmtpa1k4VU9GdjJENnR2LzQvNkRTZUJoNHFMV3BjYjl2?=
 =?utf-8?B?U3pWQS9jb2xrdjVRUkVhN1ZpeURaekZTNEZ0bVg3T3JaZVk0NWRqUnIzZ1hR?=
 =?utf-8?B?U3pBT1Nub2JsTUJwZHg3dTdLaHh2SHBPc2w3c285ZzM2ZGJKYkNUb0ZEWUZu?=
 =?utf-8?Q?Mo2o93MklF1fl+O?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19f0ef99-bf94-4c61-f1a4-08db2f75ff2e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 10:20:04.4580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6P+ksK2TJd8wGrAu7k6NtbCAJnxy4hS+TLbkvR9tHErelcqYD/xW8E9fkibA30CZBN2Ixr6xMr3AUN4sy3GbqBeVKt7cH2X88uDGG+I7RVc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5936
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-27_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303280087
X-Proofpoint-GUID: CDuhVtKGLMcc75N5hh4hrmRcU5VjVvYJ
X-Proofpoint-ORIG-GUID: CDuhVtKGLMcc75N5hh4hrmRcU5VjVvYJ
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/03/2023 10:07, Alexey Kardashevskiy wrote:
> On 17/3/23 07:02, Joao Martins wrote:
>> On KVM GSI routing table updates, specially those where they have vIOMMUs
>> with interrupt remapping enabled (to boot >255vcpus setups without relying
>> on KVM_FEATURE_MSI_EXT_DEST_ID), a VMM may update the backing VF MSIs
>> with a new VCPU affinity.
>>
>> On AMD with AVIC enabled, the new vcpu affinity info is updated via:
>>     avic_pi_update_irte()
>>         irq_set_vcpu_affinity()
>>             amd_ir_set_vcpu_affinity()
>>                 amd_iommu_{de}activate_guest_mode()
>>
>> Where the IRTE[GATag] is updated with the new vcpu affinity. The GATag
>> contains VM ID and VCPU ID, and is used by IOMMU hardware to signal KVM
>> (via GALog) when interrupt cannot be delivered due to vCPU is in
>> blocking state.
>>
>> The issue is that amd_iommu_activate_guest_mode() will essentially
>> only change IRTE fields on transitions from non-guest-mode to guest-mode
>> and otherwise returns *with no changes to IRTE* on already configured
>> guest-mode interrupts. To the guest this means that the VF interrupts
>> remain affined to the first vCPU they were first configured,and guest
>> will be unable to either VF interrupts and receive messages like this
>> from spuruious interrupts (e.g. from waking the wrong vCPU in GALog):
> 
> The "either" above sounds like there should be a verb which it is not, or is it?
> (my english skills are meh). I kinda get the idea anyway (I hope).
> 
It should be 'issue'. I'll delete the 'either'

> btw s/spuruious/spurious/, says my vim. Thanks,
> 
/me nods
