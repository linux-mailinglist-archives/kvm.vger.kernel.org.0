Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57BEB7CF3B8
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 11:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345033AbjJSJPX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 05:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjJSJPS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 05:15:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116CEFE
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 02:15:15 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39J7OTZP022778;
        Thu, 19 Oct 2023 09:14:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=2ShtwEG2Al6rdJyBBvVwkOW+3d2ifzbXToHsKctSusQ=;
 b=3pL4l/lcfgPfXeV9J7sb7yPIkUPR6317LvdBmDlifAAXg0I6FRHvXaZiuXBPwuplmwVl
 oKl3Ym5nYXjm0TsgeZWqY91hg/rfiL6OmXpcodC/kvPB65EGo182csQnjTzZ9FOXY2l4
 3KxLpOTYrpZlwPY+qWHyUFJ0sThu2FblBw+sBMD7OMrin/rjPWFSm9ppB64DnS+iKhh+
 9U2cU9OhwI+d3eRu/OezDAwTbvClp+/ndAT3L8umPsZwZ/SGMS2P/VJTUvg2YQdmASkF
 u9IS2Ynn2dzxE76EKbLIi/FOJNaU6U80uBNunVL6iaijTgkq2KtwoqqyInWqdOQ7p5/e yQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk28t7gw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Oct 2023 09:14:52 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39J8SxDN010293;
        Thu, 19 Oct 2023 09:14:51 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg0qf86b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Oct 2023 09:14:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eYXur/OVRbDKhaHau4o/R0kEgl4Ayhka9MFaduc2lxtjoLw1JG/+D2wzTcXpK7bzXdZCrLcYxzJdjMskWcs3E4XRkKyu128TYOOUXc5IXZc0OeoJqfib1TmPOxNmHi7fehfRjIzt12r1JzustLBq8zTP1NGwxopG/R3QeayCqfb1Q1tpUku5Zh9whpSvqU/KrlGKUdUEdaK+wJq40tU9nOY/qe/Xq1kCCU9PruNMl4KxHQXcT8VJZX0a/8fYZw6n90Y+dMus+Crd4MgXWbTucuO1ZvPRh32Ve7+CRRERpGTBC+csGJSZjFlDnVuImU/bYVENJfAdOLQpqR6mD/OQow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ShtwEG2Al6rdJyBBvVwkOW+3d2ifzbXToHsKctSusQ=;
 b=TuZRcjnWunHizpl4Z9WtgbVEwwWpqCiybdLLDtZGCuMoNoMlJxELcVQ6ccRjyoljnheFyHT51o3/0vkeuktlpwRtGwLjN4TfD24iytMVIvJJvkd4qXJnTI6VPHOjnu+XTxyi/BzMGl6+AEchXiq5SwyQ02PfMnF6LZJ2PZq4rsqTPmQQUxPFnlQ3e5uYG1sqW3PLwXjT0CQpHMRSvsB9PqfqbKvQMAciCKpJ3ovkdHBWTUzB64yZbDHzQy2uDMBDM8fjtdo8JU1Kl+EbWP6FXaRDtuOoSsrfD+B/jWIfwaPUMzJKEIJXYvxxzDVug2ZSx+jprhTpFMNQbBIbquIO1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ShtwEG2Al6rdJyBBvVwkOW+3d2ifzbXToHsKctSusQ=;
 b=F02iT3JMe4vmDhGLK8HblppUBz4GWpObiHcFFyx8ph5zqet9Pj7d/MQizjgw0y9hdEJl7Q120p1/5gEW1Qlahtxxzqw5RJagc7RSPVjvcGqn5baevlWER5VgjDCOhadt4XVXZiR1UL9ijLoiUwCZMvKBFK6g0PzwtdfyyfMhCOc=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CO1PR10MB4563.namprd10.prod.outlook.com (2603:10b6:303:92::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Thu, 19 Oct
 2023 09:14:48 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6907.025; Thu, 19 Oct 2023
 09:14:48 +0000
Message-ID: <c94e1114-a730-478b-8af1-5fd579517c0d@oracle.com>
Date:   Thu, 19 Oct 2023 10:14:41 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 12/18] iommu/intel: Access/Dirty bit support for SL
 domains
Content-Language: en-US
To:     Baolu Lu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-13-joao.m.martins@oracle.com>
 <fe60a4d5-e134-43fb-bab5-d29341821784@linux.intel.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <fe60a4d5-e134-43fb-bab5-d29341821784@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0067.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::18) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|CO1PR10MB4563:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e1bb8a2-5a0a-420f-49d4-08dbd083d7a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DJRm4AOOGCWbcBYhFwXfUVGr5EAI7QsIx0RzS+y0Nn0bIiaT+YkFYBi5buGrOHtA206qh4BPwC2dPHKey+kmlID9vsJUQzeF8rJZ4ngpgXhHOfAK+PEcaxJpcJG/pG4+hPxYRjZpMJHIvYFxyjrqxA4SNnUflyPa2poQ6HVZ6axZASR+Jmx2dIuRFshEFu24cuXAeU1lIJeVlRzwKElPpa72wADJobyHHBetshNwerOAt0wFxF6m/+baJHr+twN007Gi/ZRBFXJ3d2OaHjehQ6PWwwgeGtCoIqI1j/mdiXDEb1mNfB6q3izkCGXVGi+N+WrV46YidOn5JenhTlwxTeRVl/U/iWVzR9cyOhuRkmtslEr3CJRtl62FBb0PnD1QDMHDJLUwbmMLQrmNb9PIbH/94ihdHLfu/ldy8y2rf5steX8dotgS4QtpeXp/div8pxVFZxwrQfNiqYJ4XVwzUylmdPhkgyAzejavzfg7f1+/quKyWNbVnUe8Kdp05ht0XHMB1Y/P1ZBktqDo+jN/CRaFAAi0xDHpn5tUsizE8oD2ft1+HA6FHRUe9c+6i/zaqg63k9FhCUl7PwsVpEp+plXOHIfIXmUTh0lu3i9wB8lyeq44iF8y7WYiiXBC3DiwrMIQI/7ixyezh7KzLZz+uDw5J93q+2zOGTxx+2pwfowBh/urXQ2k81jU6IZnjt0bhEoYhFF4prIq58qQ4ASX1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(396003)(136003)(376002)(346002)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(54906003)(30864003)(66946007)(316002)(7416002)(2906002)(31696002)(66556008)(86362001)(5660300002)(41300700001)(8676002)(4326008)(8936002)(66476007)(36756003)(2616005)(31686004)(38100700002)(478600001)(6506007)(53546011)(6666004)(6512007)(83380400001)(6486002)(26005)(14143004)(45980500001)(43740500002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TlQ0YmlZYkZ6VHVXM1ZaQWFrRVNUWHVjWEdqa0xBVFZBSCtuUGx3c1BxN3R5?=
 =?utf-8?B?RHB6SEJCZnZKMGFrZm93S1A1RTZXd3p6SVczV2txUEQ2R2tZWjd6WnpkT3Fu?=
 =?utf-8?B?UHkwSjRpR0JGT28zYWFKeEZUV0VyWGpHYzAvWmJWWS9kZ0FST2R4YVlSZVcx?=
 =?utf-8?B?YVpKa1ZjY2lDSG43ZjB1dlNQRjdnWHArYUFEc3Fjb0lZL09HUFAvb2dJTG83?=
 =?utf-8?B?UktXclZUTWltSEpUWlpMRzNoTUZxdzQrYmVpSUZ3bHFVbjNQNFpTYUY3U1ZP?=
 =?utf-8?B?TnpCZnVFSllqRFNiS1dhZ21nZ2RFRzRKSEs5QlpUdjVocUNFVFNuVlJRUzNF?=
 =?utf-8?B?OThKNjFlakxHTEhRaWVmcGRtYVl5UnF5T3FzNWFZVUNnSFVaSlZzU3pqWlAy?=
 =?utf-8?B?bGZJSzR2clBxbGExRmFyR0x1TElYaE5VdU12a1FtUzBTcHZYcm1HNHc4UU13?=
 =?utf-8?B?N2p5am5DdU9Hd3FjQ1JKUkQ1N2JRMVhYUEZlMEMxSC9UV1NFN0xXNkxod2tK?=
 =?utf-8?B?Y2VBL1pIRmhoeUs2eUFrQXVTTmZxL2RYT0kzeDNHdFJNVGZ4NDFjaFIxZ2pV?=
 =?utf-8?B?aHZlN1dleDRhQ09SdmxCaEJQNk5LUW5JNG9oMkhUd2JaVmJySG1BMmN2eWNr?=
 =?utf-8?B?Lzd1YnlLSFFqK2RJZHdVQnVlcEFSN3JNRTlKMldDa0UvR011NUpQOTZGMFpu?=
 =?utf-8?B?bmdYUkhEZ05zWDFzRjhzRjlSdTR2a3p4Wi9hLzBGWE9XTEtla3JtZjBqazc5?=
 =?utf-8?B?VkVtZmloQUt2SFUvVDVXTEluaTJYQWdSWUU0ZkVOUlpWeFVGSEZqb2Izak1D?=
 =?utf-8?B?cW5hVU5kWmNRVW1FYVhuTTlWN0ZkLzBLWDgvVk1JRkE0VE8zVGxOTTB0Tm9s?=
 =?utf-8?B?Mkd0SXVLRml5b2dpUGplMG1XUFdBdXRqWEIwQmZkWi8ydldieWlUVmhhTm9Q?=
 =?utf-8?B?a3Z4UWhIWXRZaUtYQ1pCbXZ5cEY2TU9MZGsyL280ZmNCNmU5d005K1FsVGc5?=
 =?utf-8?B?LzUxbS82UmxLa0cxWGVQQTJjdzY3b1pFdzYvWEdMeUJzRHF1Q3phL2FEbVIw?=
 =?utf-8?B?L2c3QUVYMlM5WmFPeEJEQ2ZpTmNHeHNxOEFoUExUSk1pejhsQXd5ZjF1bXU1?=
 =?utf-8?B?N2EzTCtHdHZ1aDFTNUNka2xCWFFpSTF3Y2xCeFVRbFNhalRET2ZyY1d3d3BC?=
 =?utf-8?B?TzVwNFlMbUNtUy9pOHVkZ1RUMWIxZnBGYUQ0QXJkbTV1SmRKSmV4YWxUcTQ0?=
 =?utf-8?B?ajZ1c3BEK3p2TVFpbWdpbGRyMWEyV1dZdWRLMXB5QXNvSFBSWUxtQUJHdjZX?=
 =?utf-8?B?VmtKc0hxdkMvVE9Nb2o0UXROdnBuZEJqalM2VDNZTmkwN0JRbkp1cUpiNWcz?=
 =?utf-8?B?eTNtVDZ3Z0puRXpMWERkQWo1Y2lmSnNzSUQ2VXRCNHI2MGZjeEI5NWdHWUtr?=
 =?utf-8?B?T2hjTXNPUnpmSWNRRWJIMDdqa0RZaXNzNXZoRktFVU56Y1hDa0tRMEYrODl1?=
 =?utf-8?B?ZVJoNm1vN2ZJQ2RRM3NBc0JwTW5nZlBsdldkQVBVNFdQNXpaT01zcWJjN3pX?=
 =?utf-8?B?VmRXSGhqQ3VKUE1Kdmg4MDlpdTFEQzFaemZnRENkWDh3cVUveDNESEpSZk9o?=
 =?utf-8?B?RFVRNVIwL2lZSjlDa2ZMUlhtYVFkUU5vV3VyMkhGWjd2eDF6Z0UrMENVc3NU?=
 =?utf-8?B?REVLd1Q4Ym9IUUowWGxLdUpQRlV1MDhDTTRVbk5IeHdaaE1oZENyUGFRL1FK?=
 =?utf-8?B?ZzNVV1d3VFYyQ1JTdHovYy9scE9GSk9uZVptekJ1UjNaelZ6a2JEcmdRWUlR?=
 =?utf-8?B?aWdydkJtNjBsdnV5UGNueGtQZk5HeTF2eUJrVnFmeWZuN1UyRi8yV1F4NVVp?=
 =?utf-8?B?SWFrWnlZYTRhWHlIcjZQcHlmUVRNSHFhajlJaFZsT2dMQys1KzBraUNaMTBp?=
 =?utf-8?B?cW42Yld4d0pXTnhGaGphRVFRY2d6Ym9GM0E4c0FydS9RMHRrSmYrdkU1NjZR?=
 =?utf-8?B?UTdMRlhub3BaMXZIUGwzZlpML2l5TEZOSkt0SkxNTG5LSTJ3S1U3L25vR3p4?=
 =?utf-8?B?cGtTbG10YzJhMkExNHZYRjg5WjlMQjVyYWNLay9QSjhxUjZJdDN0WlFMWDRx?=
 =?utf-8?B?UndZTlc4c1l2Y3R5WDgwY2pjNDhyZzhhMDNMT1RDbk9GeHdIcUFZalZEZ3N6?=
 =?utf-8?B?akE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?MVU5TjZWK1p5K3JpVjNVS3JIbWRNdnZTQ2d5Q0QrSURUMXNLb0hNbUs0bG1x?=
 =?utf-8?B?VXhiSlFyeDZteUtWVkZEK2w0RUxlZExWQnhOb2RnR0RxOS9TSGlXWTQ1VDRY?=
 =?utf-8?B?azFtaVR0Mml4VFZFQmIwYUptV3N6VHBFOVRoZGVSQWN5LzZoNGFaN2laSXFz?=
 =?utf-8?B?RkZjMFQ0VXVIOHRtSEc4RXNmSExrUXRqZ2JBUHluZG1zWmFwa0RwNG9uWkJP?=
 =?utf-8?B?elZwRG1QeERoVEFMVXk2NFNpL252TnlSanVyQ05rb2Jzd21aOFhXaDQ3NHhF?=
 =?utf-8?B?bCtYOWc3aE51anlidGhXWGRxU0VTN2hzNGxoRXBPNVNXY25qWmZjdlhIUCtN?=
 =?utf-8?B?V3JXM2RWd1pZYjBvT29hWnJqYkJsRFVmWmRCNjc2S3FJamxvYzFDT2JJS0dU?=
 =?utf-8?B?WldLa3hKY3JncU90cnFWV1FheG1HbmVpeThtVHFBU29UdHY5dGZTUytnZnJY?=
 =?utf-8?B?aUFIaHlMNGJmTjUzUitXZS9SYUhDWFdnMWk3M1I3OEVSczJrc3BZVnpiYjNr?=
 =?utf-8?B?RHlUbEovRkVmWXh3UHBTTHVxWUxaRGtwWHpUbzVzZnR2dmxsOXYxcjgyK3hv?=
 =?utf-8?B?NFR1MEhJaVBPUmVaNWlOMG5lem9EMDJvZW0va2ROTmViRGZYMWdMZ1ZkdjE5?=
 =?utf-8?B?dnh0dXhMQzhTWnFMUStKTHp1N0M0ekZ1N1BBUXI3U2RWTmJzQzRCL1IreXZO?=
 =?utf-8?B?WjFHYXgvV1owVE1FTDl3aFZXN2s4bVhnTUc5Lyt5Tll6ZEtlRzdNNFpTT0s1?=
 =?utf-8?B?ZDJUWU9QS3YwVTkrTTdWZEJzRGFSNGMvNjFKWFN5bC93cFZ4VHdLWjY1bHRJ?=
 =?utf-8?B?TXpWaTVBcm9TNjBVU2VpVVdJbEhLa29PQVh6aXdNR0NFRFF2Y3poNEhXamRw?=
 =?utf-8?B?QVVZSmxXL0dIck8zMFJBdllFdWZkVlhKcldHa0VkZlJwbGtiMUZJRFhhUU5Y?=
 =?utf-8?B?NXd4Rk93NTFpeWRHcURtRWg2dFdIdjU3azZVR0dvWnFGYzdTbTdnZElkTmdz?=
 =?utf-8?B?VWhTOU1GenVvdEx3NDlQSG9hVGExdUV1ZkpUdEdZKzJOQzFsM0NzWDgrd01X?=
 =?utf-8?B?Y2s4NHhKZE8yT0thcFpxVkgzZ3hlRjhNYzJlT0NJRmh2NC9mV1VNUXlmQTVL?=
 =?utf-8?B?T0cvajBzVzVaQVorZ2RBQlo5T1p2QkpxREdTSUxINnVBcFlIbFRpRkpZczRr?=
 =?utf-8?B?QmpWQTVUTFp6UkVlZUtsNFhDQXQvcHhFL0gxVXh6SnN4czZCQjBxTDRJMWEz?=
 =?utf-8?B?QkVkZGZuVWdGdzF3OFdOMDNNTWt1RmI1TU1MbDdEWHBuakVKdytvTStCZFo5?=
 =?utf-8?B?ZHZFajFrYzhtb0YwTm5iRnVrWWJqWWs5VGZhdk1GZzV4TU1SWXBZL3dmakFU?=
 =?utf-8?B?RFFGamJqbkhoejhRNHROSm0rcVRuN1duOWc4QW1ZQVhPbTVteGdXMitRUkxY?=
 =?utf-8?Q?3WVriO/i?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e1bb8a2-5a0a-420f-49d4-08dbd083d7a7
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2023 09:14:48.3590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xzU/8vVkgylUHTqjBZ00zCOAQAY3PlzTEW+XEg0X13Xjljm+jkvpMP42hU0hvp2YLSRYoePdaqzKO9MHnDM6UGu9oySab3lYPqMqv2dYEyI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4563
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-19_06,2023-10-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310190077
X-Proofpoint-ORIG-GUID: 0qBRrswX7nUfUAbWfqZo86qMRr9a8QCA
X-Proofpoint-GUID: 0qBRrswX7nUfUAbWfqZo86qMRr9a8QCA
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/10/2023 04:04, Baolu Lu wrote:
> On 10/19/23 4:27 AM, Joao Martins wrote:
>> IOMMU advertises Access/Dirty bits for second-stage page table if the
>> extended capability DMAR register reports it (ECAP, mnemonic ECAP.SSADS).
>> The first stage table is compatible with CPU page table thus A/D bits are
>> implicitly supported. Relevant Intel IOMMU SDM ref for first stage table
>> "3.6.2 Accessed, Extended Accessed, and Dirty Flags" and second stage table
>> "3.7.2 Accessed and Dirty Flags".
>>
>> First stage page table is enabled by default so it's allowed to set dirty
>> tracking and no control bits needed, it just returns 0. To use SSADS, set
>> bit 9 (SSADE) in the scalable-mode PASID table entry and flush the IOTLB
>> via pasid_flush_caches() following the manual. Relevant SDM refs:
>>
>> "3.7.2 Accessed and Dirty Flags"
>> "6.5.3.3 Guidance to Software for Invalidations,
>>   Table 23. Guidance to Software for Invalidations"
>>
>> PTE dirty bit is located in bit 9 and it's cached in the IOTLB so flush
>> IOTLB to make sure IOMMU attempts to set the dirty bit again. Note that
>> iommu_dirty_bitmap_record() will add the IOVA to iotlb_gather and thus the
>> caller of the iommu op will flush the IOTLB. Relevant manuals over the
>> hardware translation is chapter 6 with some special mention to:
>>
>> "6.2.3.1 Scalable-Mode PASID-Table Entry Programming Considerations"
>> "6.2.4 IOTLB"
>>
>> Select IOMMUFD_DRIVER only if IOMMUFD is enabled, given that IOMMU dirty
>> tracking requires IOMMUFD.
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>   drivers/iommu/intel/Kconfig |   1 +
>>   drivers/iommu/intel/iommu.c | 104 +++++++++++++++++++++++++++++++++-
>>   drivers/iommu/intel/iommu.h |  17 ++++++
>>   drivers/iommu/intel/pasid.c | 109 ++++++++++++++++++++++++++++++++++++
>>   drivers/iommu/intel/pasid.h |   4 ++
>>   5 files changed, 234 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/iommu/intel/Kconfig b/drivers/iommu/intel/Kconfig
>> index 2e56bd79f589..f5348b80652b 100644
>> --- a/drivers/iommu/intel/Kconfig
>> +++ b/drivers/iommu/intel/Kconfig
>> @@ -15,6 +15,7 @@ config INTEL_IOMMU
>>       select DMA_OPS
>>       select IOMMU_API
>>       select IOMMU_IOVA
>> +    select IOMMUFD_DRIVER if IOMMUFD
>>       select NEED_DMA_MAP_STATE
>>       select DMAR_TABLE
>>       select SWIOTLB
>> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
>> index 017aed5813d8..405b459416d5 100644
>> --- a/drivers/iommu/intel/iommu.c
>> +++ b/drivers/iommu/intel/iommu.c
>> @@ -300,6 +300,7 @@ static int iommu_skip_te_disable;
>>   #define IDENTMAP_AZALIA        4
>>     const struct iommu_ops intel_iommu_ops;
>> +const struct iommu_dirty_ops intel_dirty_ops;
>>     static bool translation_pre_enabled(struct intel_iommu *iommu)
>>   {
>> @@ -4077,10 +4078,12 @@ static struct iommu_domain
>> *intel_iommu_domain_alloc(unsigned type)
>>   static struct iommu_domain *
>>   intel_iommu_domain_alloc_user(struct device *dev, u32 flags)
>>   {
>> +    bool enforce_dirty = (flags & IOMMU_HWPT_ALLOC_ENFORCE_DIRTY);
>>       struct iommu_domain *domain;
>>       struct intel_iommu *iommu;
>>   -    if (flags & (~IOMMU_HWPT_ALLOC_NEST_PARENT))
>> +    if (flags & (~(IOMMU_HWPT_ALLOC_NEST_PARENT|
>> +               IOMMU_HWPT_ALLOC_ENFORCE_DIRTY)))
>>           return ERR_PTR(-EOPNOTSUPP);
>>         iommu = device_to_iommu(dev, NULL, NULL);
>> @@ -4090,6 +4093,9 @@ intel_iommu_domain_alloc_user(struct device *dev, u32
>> flags)
>>       if ((flags & IOMMU_HWPT_ALLOC_NEST_PARENT) && !ecap_nest(iommu->ecap))
>>           return ERR_PTR(-EOPNOTSUPP);
>>   +    if (enforce_dirty && !slads_supported(iommu))
>> +        return ERR_PTR(-EOPNOTSUPP);
>> +
>>       /*
>>        * domain_alloc_user op needs to fully initialize a domain
>>        * before return, so uses iommu_domain_alloc() here for
>> @@ -4098,6 +4104,15 @@ intel_iommu_domain_alloc_user(struct device *dev, u32
>> flags)
>>       domain = iommu_domain_alloc(dev->bus);
>>       if (!domain)
>>           domain = ERR_PTR(-ENOMEM);
>> +
>> +    if (!IS_ERR(domain) && enforce_dirty) {
>> +        if (to_dmar_domain(domain)->use_first_level) {
>> +            iommu_domain_free(domain);
>> +            return ERR_PTR(-EOPNOTSUPP);
>> +        }
>> +        domain->dirty_ops = &intel_dirty_ops;
>> +    }
>> +
>>       return domain;
>>   }
>>   @@ -4121,6 +4136,9 @@ static int prepare_domain_attach_device(struct
>> iommu_domain *domain,
>>       if (dmar_domain->force_snooping && !ecap_sc_support(iommu->ecap))
>>           return -EINVAL;
>>   +    if (domain->dirty_ops && !slads_supported(iommu))
>> +        return -EINVAL;
>> +
>>       /* check if this iommu agaw is sufficient for max mapped address */
>>       addr_width = agaw_to_width(iommu->agaw);
>>       if (addr_width > cap_mgaw(iommu->cap))
>> @@ -4375,6 +4393,8 @@ static bool intel_iommu_capable(struct device *dev, enum
>> iommu_cap cap)
>>           return dmar_platform_optin();
>>       case IOMMU_CAP_ENFORCE_CACHE_COHERENCY:
>>           return ecap_sc_support(info->iommu->ecap);
>> +    case IOMMU_CAP_DIRTY:
>> +        return slads_supported(info->iommu);
>>       default:
>>           return false;
>>       }
>> @@ -4772,6 +4792,9 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain
>> *domain,
>>       if (!pasid_supported(iommu) || dev_is_real_dma_subdevice(dev))
>>           return -EOPNOTSUPP;
>>   +    if (domain->dirty_ops)
>> +        return -EINVAL;
>> +
>>       if (context_copied(iommu, info->bus, info->devfn))
>>           return -EBUSY;
>>   @@ -4830,6 +4853,85 @@ static void *intel_iommu_hw_info(struct device *dev,
>> u32 *length, u32 *type)
>>       return vtd;
>>   }
>>   +static int intel_iommu_set_dirty_tracking(struct iommu_domain *domain,
>> +                      bool enable)
>> +{
>> +    struct dmar_domain *dmar_domain = to_dmar_domain(domain);
>> +    struct device_domain_info *info;
>> +    int ret = -EINVAL;
>> +
>> +    spin_lock(&dmar_domain->lock);
>> +    if (dmar_domain->dirty_tracking == enable)
>> +        goto out_unlock;
>> +
>> +    list_for_each_entry(info, &dmar_domain->devices, link) {
>> +        ret = intel_pasid_setup_dirty_tracking(info->iommu, info->domain,
>> +                             info->dev, IOMMU_NO_PASID,
>> +                             enable);
>> +        if (ret)
>> +            goto err_unwind;
>> +
>> +    }
>> +
>> +    if (!ret)
>> +        dmar_domain->dirty_tracking = enable;
> 
> We should also support setting dirty tracking even if the domain has not
> been attached to any device?
> 
Considering this rides on hwpt-alloc which attaches a device on domain
allocation, then this shouldn't be possible in pratice. But I take this is to
improve 'future' resilience, as there's nothing bad coming from below change you
suggested.

> To achieve this, we can remove ret initialization and remove the above
> check. Make the default path a successful one.
> 
>     int ret;
> 
>     [...]
> 
>     dmar_domain->dirty_tracking = enable;
> 
OK, if above makes sense.

>> +out_unlock:
>> +    spin_unlock(&dmar_domain->lock);
>> +
>> +    return 0;
>> +
>> +err_unwind:
>> +    list_for_each_entry(info, &dmar_domain->devices, link)
>> +        intel_pasid_setup_dirty_tracking(info->iommu, dmar_domain,
>> +                      info->dev, IOMMU_NO_PASID,
>> +                      dmar_domain->dirty_tracking);
>> +    spin_unlock(&dmar_domain->lock);
>> +    return ret;
>> +}
>> +
>> +static int intel_iommu_read_and_clear_dirty(struct iommu_domain *domain,
>> +                        unsigned long iova, size_t size,
>> +                        unsigned long flags,
>> +                        struct iommu_dirty_bitmap *dirty)
>> +{
>> +    struct dmar_domain *dmar_domain = to_dmar_domain(domain);
>> +    unsigned long end = iova + size - 1;
>> +    unsigned long pgsize;
>> +
>> +    /*
>> +     * IOMMUFD core calls into a dirty tracking disabled domain without an
>> +     * IOVA bitmap set in order to clean dirty bits in all PTEs that might
>> +     * have occurred when we stopped dirty tracking. This ensures that we
>> +     * never inherit dirtied bits from a previous cycle.
>> +     */
>> +    if (!dmar_domain->dirty_tracking && dirty->bitmap)
>> +        return -EINVAL;
>> +
>> +    do {
>> +        struct dma_pte *pte;
>> +        int lvl = 0;
>> +
>> +        pte = pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT, &lvl,
>> +                     GFP_ATOMIC);
>> +        pgsize = level_size(lvl) << VTD_PAGE_SHIFT;
>> +        if (!pte || !dma_pte_present(pte)) {
>> +            iova += pgsize;
>> +            continue;
>> +        }
>> +
>> +        if (dma_sl_pte_test_and_clear_dirty(pte, flags))
>> +            iommu_dirty_bitmap_record(dirty, iova, pgsize);
>> +        iova += pgsize;
>> +    } while (iova < end);
>> +
>> +    return 0;
>> +}
>> +
>> +const struct iommu_dirty_ops intel_dirty_ops = {
>> +    .set_dirty_tracking    = intel_iommu_set_dirty_tracking,
>> +    .read_and_clear_dirty   = intel_iommu_read_and_clear_dirty,
>> +};
>> +
>>   const struct iommu_ops intel_iommu_ops = {
>>       .capable        = intel_iommu_capable,
>>       .hw_info        = intel_iommu_hw_info,
>> diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
>> index c18fb699c87a..27bcfd3bacdd 100644
>> --- a/drivers/iommu/intel/iommu.h
>> +++ b/drivers/iommu/intel/iommu.h
>> @@ -48,6 +48,9 @@
>>   #define DMA_FL_PTE_DIRTY    BIT_ULL(6)
>>   #define DMA_FL_PTE_XD        BIT_ULL(63)
>>   +#define DMA_SL_PTE_DIRTY_BIT    9
>> +#define DMA_SL_PTE_DIRTY    BIT_ULL(DMA_SL_PTE_DIRTY_BIT)
>> +
>>   #define ADDR_WIDTH_5LEVEL    (57)
>>   #define ADDR_WIDTH_4LEVEL    (48)
>>   @@ -539,6 +542,9 @@ enum {
>>   #define sm_supported(iommu)    (intel_iommu_sm && ecap_smts((iommu)->ecap))
>>   #define pasid_supported(iommu)    (sm_supported(iommu) &&            \
>>                    ecap_pasid((iommu)->ecap))
>> +#define slads_supported(iommu) (sm_supported(iommu) &&                 \
>> +                ecap_slads((iommu)->ecap))
>> +
>>     struct pasid_entry;
>>   struct pasid_state_entry;
>> @@ -592,6 +598,7 @@ struct dmar_domain {
>>                        * otherwise, goes through the second
>>                        * level.
>>                        */
>> +    u8 dirty_tracking:1;        /* Dirty tracking is enabled */
>>         spinlock_t lock;        /* Protect device tracking lists */
>>       struct list_head devices;    /* all devices' list */
>> @@ -781,6 +788,16 @@ static inline bool dma_pte_present(struct dma_pte *pte)
>>       return (pte->val & 3) != 0;
>>   }
>>   +static inline bool dma_sl_pte_test_and_clear_dirty(struct dma_pte *pte,
>> +                           unsigned long flags)
>> +{
>> +    if (flags & IOMMU_DIRTY_NO_CLEAR)
>> +        return (pte->val & DMA_SL_PTE_DIRTY) != 0;
>> +
>> +    return test_and_clear_bit(DMA_SL_PTE_DIRTY_BIT,
>> +                  (unsigned long *)&pte->val);
>> +}
>> +
>>   static inline bool dma_pte_superpage(struct dma_pte *pte)
>>   {
>>       return (pte->val & DMA_PTE_LARGE_PAGE);
>> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
>> index 8f92b92f3d2a..785384a59d55 100644
>> --- a/drivers/iommu/intel/pasid.c
>> +++ b/drivers/iommu/intel/pasid.c
>> @@ -277,6 +277,11 @@ static inline void pasid_set_bits(u64 *ptr, u64 mask, u64
>> bits)
>>       WRITE_ONCE(*ptr, (old & ~mask) | bits);
>>   }
>>   +static inline u64 pasid_get_bits(u64 *ptr)
>> +{
>> +    return READ_ONCE(*ptr);
>> +}
>> +
>>   /*
>>    * Setup the DID(Domain Identifier) field (Bit 64~79) of scalable mode
>>    * PASID entry.
>> @@ -335,6 +340,36 @@ static inline void pasid_set_fault_enable(struct
>> pasid_entry *pe)
>>       pasid_set_bits(&pe->val[0], 1 << 1, 0);
>>   }
>>   +/*
>> + * Enable second level A/D bits by setting the SLADE (Second Level
>> + * Access Dirty Enable) field (Bit 9) of a scalable mode PASID
>> + * entry.
>> + */
>> +static inline void pasid_set_ssade(struct pasid_entry *pe)
>> +{
>> +    pasid_set_bits(&pe->val[0], 1 << 9, 1 << 9);
>> +}
>> +
>> +/*
>> + * Enable second level A/D bits by setting the SLADE (Second Level
> 
> nit: Disable second level ....
> 
/me nods

>> + * Access Dirty Enable) field (Bit 9) of a scalable mode PASID
>> + * entry.
>> + */
>> +static inline void pasid_clear_ssade(struct pasid_entry *pe)
>> +{
>> +    pasid_set_bits(&pe->val[0], 1 << 9, 0);
>> +}
>> +
>> +/*
>> + * Checks if second level A/D bits by setting the SLADE (Second Level
>> + * Access Dirty Enable) field (Bit 9) of a scalable mode PASID
>> + * entry is enabled.
>> + */
>> +static inline bool pasid_get_ssade(struct pasid_entry *pe)
>> +{
>> +    return pasid_get_bits(&pe->val[0]) & (1 << 9);
>> +}
>> +
>>   /*
>>    * Setup the WPE(Write Protect Enable) field (Bit 132) of a
>>    * scalable mode PASID entry.
>> @@ -627,6 +662,8 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
>>       pasid_set_translation_type(pte, PASID_ENTRY_PGTT_SL_ONLY);
>>       pasid_set_fault_enable(pte);
>>       pasid_set_page_snoop(pte, !!ecap_smpwc(iommu->ecap));
>> +    if (domain->dirty_tracking)
>> +        pasid_set_ssade(pte);
>>         pasid_set_present(pte);
>>       spin_unlock(&iommu->lock);
>> @@ -636,6 +673,78 @@ int intel_pasid_setup_second_level(struct intel_iommu
>> *iommu,
>>       return 0;
>>   }
>>   +/*
>> + * Set up dirty tracking on a second only translation type.
> 
> nit: ... on a second only or nested translation type.
> 
OK -- had changed the check, but not the comment :/

>> + */
>> +int intel_pasid_setup_dirty_tracking(struct intel_iommu *iommu,
>> +                     struct dmar_domain *domain,
>> +                     struct device *dev, u32 pasid,
>> +                     bool enabled)
>> +{
>> +    struct pasid_entry *pte;
>> +    u16 did, pgtt;
>> +
>> +    spin_lock(&iommu->lock);
>> +
>> +    pte = intel_pasid_get_entry(dev, pasid);
>> +    if (!pte) {
>> +        spin_unlock(&iommu->lock);
>> +        dev_err_ratelimited(dev,
>> +                    "Failed to get pasid entry of PASID %d\n",
>> +                    pasid);
>> +        return -ENODEV;
>> +    }
>> +
>> +    did = domain_id_iommu(domain, iommu);
>> +    pgtt = pasid_pte_get_pgtt(pte);
>> +    if (pgtt != PASID_ENTRY_PGTT_SL_ONLY && pgtt != PASID_ENTRY_PGTT_NESTED) {
>> +        spin_unlock(&iommu->lock);
>> +        dev_err_ratelimited(dev,
>> +                    "Dirty tracking not supported on translation type %d\n",
>> +                    pgtt);
>> +        return -EOPNOTSUPP;
>> +    }
>> +
>> +    if (pasid_get_ssade(pte) == enabled) {
>> +        spin_unlock(&iommu->lock);
>> +        return 0;
>> +    }
>> +
>> +    if (enabled)
>> +        pasid_set_ssade(pte);
>> +    else
>> +        pasid_clear_ssade(pte);
>> +    spin_unlock(&iommu->lock);
>> +
>> +    if (!ecap_coherent(iommu->ecap))
>> +        clflush_cache_range(pte, sizeof(*pte));
>> +
>> +    /*
>> +     * From VT-d spec table 25 "Guidance to Software for Invalidations":
>> +     *
>> +     * - PASID-selective-within-Domain PASID-cache invalidation
>> +     *   If (PGTT=SS or Nested)
>> +     *    - Domain-selective IOTLB invalidation
>> +     *   Else
>> +     *    - PASID-selective PASID-based IOTLB invalidation
>> +     * - If (pasid is RID_PASID)
>> +     *    - Global Device-TLB invalidation to affected functions
>> +     *   Else
>> +     *    - PASID-based Device-TLB invalidation (with S=1 and
>> +     *      Addr[63:12]=0x7FFFFFFF_FFFFF) to affected functions
>> +     */
>> +    pasid_cache_invalidation_with_pasid(iommu, did, pasid);
>> +
>> +    if (pgtt == PASID_ENTRY_PGTT_SL_ONLY || pgtt == PASID_ENTRY_PGTT_NESTED)
> 
> Above check is unnecessary.
> 
Ah yes, we're validating beforehand above.

>> +        iommu->flush.flush_iotlb(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH);
>> +
>> +    /* Device IOTLB doesn't need to be flushed in caching mode. */
>> +    if (!cap_caching_mode(iommu->cap))
>> +        devtlb_invalidation_with_pasid(iommu, dev, pasid);
>> +
>> +    return 0;
>> +}
>> +
>>   /*
>>    * Set up the scalable mode pasid entry for passthrough translation type.
>>    */
>> diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
>> index 4e9e68c3c388..958050b093aa 100644
>> --- a/drivers/iommu/intel/pasid.h
>> +++ b/drivers/iommu/intel/pasid.h
>> @@ -106,6 +106,10 @@ int intel_pasid_setup_first_level(struct intel_iommu *iommu,
>>   int intel_pasid_setup_second_level(struct intel_iommu *iommu,
>>                      struct dmar_domain *domain,
>>                      struct device *dev, u32 pasid);
>> +int intel_pasid_setup_dirty_tracking(struct intel_iommu *iommu,
>> +                     struct dmar_domain *domain,
>> +                     struct device *dev, u32 pasid,
>> +                     bool enabled);
>>   int intel_pasid_setup_pass_through(struct intel_iommu *iommu,
>>                      struct dmar_domain *domain,
>>                      struct device *dev, u32 pasid);
> 
> Others look good to me. Thank you very much!
> 
> With above addressed,
> 
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> 
Thanks
