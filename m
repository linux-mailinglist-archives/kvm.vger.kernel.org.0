Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23F4C7D3C9B
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 18:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbjJWQcG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 12:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbjJWQcC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 12:32:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2587F10C7
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 09:31:58 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39NFO1UG021902;
        Mon, 23 Oct 2023 16:31:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=MyaCBLT89EUzLpRE59byM40V/dbuwbt6uvFW1jXMUXs=;
 b=fjZrX7FldkGQ++R9SrJ6L9XZc/GSitYGK/EDSl72naTwXNwYctlnlJMVxpSWO3Cq+HnY
 cLyWF3iCP1/n/K7U7+/tGVjMRApchdntsXyhwtQSrQ4GgFTB/xf26+lX8kynpRJWBGeL
 P8HWmnwPzLeHb4aveVZ3tZEf4uFc6NdYl4dO73tBoI2oGOulEOKbH3fyh9czXi8PUg+L
 bUSzDot7d3mMLoGR94DHkEhWEEfAQU0SJINRZwlG6oHbbB5DqXrUplQzMx+52N3wLc8Z
 Ahvywmfu/6x92hTjEhBYPXwywZ+U0JssIypF08x5wj/bqCR397kJo0IcWp7pL2nDMoTc qQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv68tbj0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 16:31:31 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39NFkqtv018914;
        Mon, 23 Oct 2023 16:31:31 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tv534ea4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 16:31:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gYx23viTH9Ow3WrNVrKXVWrkYoilrTcJbnRgH87FWODDzByLm3p+W10LRsYNGFGCo6flprPa9U3d9q1hJd1CqDt29wjyyiurB59YaeGuzMwx0TWIwKVmnqSGM0L9XbOz1oqp1jjsp4kcCEhFi4GNDHNfu+GoPGZplQ09uHbw6Qa17Mr/XStHneTfp8aOr9aW0uM9jaJVacu8dr+nQGGd4jk/qUZ/NPwptSCqGjX+7PBXpTZjecryUQpde1Dr5Qvb+8iBNtE9vx5q3E9KaXQZ54hifN5ZGc7vRimOmCVbWP82nA+LIUZqsSdQeMXvg+SyfRbXXu5C9ywiewvfyzY+wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MyaCBLT89EUzLpRE59byM40V/dbuwbt6uvFW1jXMUXs=;
 b=EeqnbaoC+cQfKcYp/Yhgh3x/j4tamDA8upqCqYWi5feLmS2lnvz4+tMiOykyTeeCqTt8RnFSYeGnXr5id3xpiGTpw1XfaA7vTz5NXCid4h7kjQgsjCTXbnY3UhIgRwoCiA4CbrG9wXbHv9NGcM0OqMqvwYGwAqdERgWlag3A2OeiNdLJa+1vfllKh+UCr1DubiwNNlIeG7CM8FUBijHPb682VBQ79XXYAAAz31zu4BRP8+broOI5r3tiX1IJBmBMNQQiKvth+YfqXafSIcCxSLyCoLEAXZUpSzz/D46q2e1hm7M6JGPcNHm8h/W0IH5VMDDEmXevfdtLHcnD2PdQmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MyaCBLT89EUzLpRE59byM40V/dbuwbt6uvFW1jXMUXs=;
 b=h3F39hEVy/xOHxqryz8Hr2wDewdnLBNx0EKxq1JVTPMs/VHAfXpLYRqCnkx7REPXL4Bd6Glmn4heuxi97qkNNQFkuOE1OWMgK9oICBWmjD1vjRH23NYwpcdbKY1Xikgcs32Cdhvnf65xTO6xNODl3SjUl1Ja+2RLMygp0FEv9z8=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by PH0PR10MB4598.namprd10.prod.outlook.com (2603:10b6:510:34::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.29; Mon, 23 Oct
 2023 16:31:28 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac%3]) with mapi id 15.20.6907.032; Mon, 23 Oct 2023
 16:31:28 +0000
Message-ID: <f511e068-802b-4be2-8cbd-ae67f27078e7@oracle.com>
Date:   Mon, 23 Oct 2023 17:31:22 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/18] iommufd: Add IOMMU_HWPT_GET_DIRTY_BITMAP
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Baolu Lu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20231020222804.21850-1-joao.m.martins@oracle.com>
 <20231020222804.21850-8-joao.m.martins@oracle.com>
 <b7834d1e-d198-45ee-b15d-12bd235bc57f@app.fastmail.com>
 <d65cb92a-8d2c-41a3-83b1-899310db1a20@oracle.com>
 <20231023121013.GQ3952@nvidia.com>
 <5a809f02-f102-4488-9fb2-bd4eb1c94999@app.fastmail.com>
 <7067efd0-e872-4ff6-b53b-d41bbbe1ea1e@oracle.com>
 <20231023161627.GA3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231023161627.GA3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0010.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::20) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|PH0PR10MB4598:EE_
X-MS-Office365-Filtering-Correlation-Id: e1b0c557-e857-46ae-43b9-08dbd3e581e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Kr3/b3KgyLMQIHyU6zIoVKBhgdFQEOHPvdY5O4hWM+TyA8dGtxTB6XgX70kTfkKRdNPLcfa7UGbxjfPtiIJr/Td2LTGf/uhA73fb5K1rx/QWbNgTtjSaTuJ3xYyQymLgse2Xje/I+7sYYbbNMZLhpUlLPagwZSfugnoJ66sOoTUEQ8b7eUJx1s8/fqquYXavT8q9S6W1sqWjJTDA8OXfjtGafXUlt3vuBV0cmKq4R6Kg1hVtTEzpMquVZ/GvLHuGZmbShGgmoiPdZdCuMQ6/yxoM3f9np+8bbuzcyBHlHe3X5rU/mKA513mn7eoqCT9rpONJaTdh5kA+cBQ+7Bn9tdNM1gjSxfYvsBtKPd04f3836a3MWpn6RJ9aVM4Z1GJyK7tOi3gklJO+ekLw2DR/2xIhmvfPysPxQ0wezVgQ7zTaT6N+TxmEXWhPj2NzIEUSXKHSyg0bMWX7562eGXrhWdux9Br+JkMaVZcMnnYOaTajMr+e7XCpMv8mVz3QEP4OO0N6nXW5lKDi6bSodQ2/6cEno3VsOe02GDE38VW8ICBsa52mMPP+TFUxwvjk4fo2eW9kOEHZEetYpe5RXDwozIb1yvq04Q16NucNhest99ATWkw3oP4DshgJfl3GJJyLf3po4Zn6nBM4Ne7LZlNv/tlO8z1I/n5mSZI27tQRog=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(136003)(376002)(396003)(39860400002)(230922051799003)(451199024)(186009)(64100799003)(1800799009)(26005)(31686004)(38100700002)(2906002)(41300700001)(86362001)(5660300002)(36756003)(7416002)(31696002)(4326008)(8676002)(8936002)(6916009)(2616005)(6666004)(478600001)(6506007)(66946007)(316002)(66476007)(54906003)(66556008)(6486002)(6512007)(53546011)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NGVIclhTZ1ZvbFVtTXNWZ0IwZHR1b0xJR2laT2FRTDlaZmpZcW9XNjhEdTNn?=
 =?utf-8?B?bmxSdnFPbzZlVmc1QzNsbE9oUHhsWU02bUJwVHhuMFAyQ1kxNGhxbURBRHJT?=
 =?utf-8?B?T3J5amxuR1hnbHVrSVQxTWF4K2U4TFljVlRhUWM2V0N2VTJnR1FYTnNuclBo?=
 =?utf-8?B?cnZjeGFDTTZla2NlZVpUWFJjcC9rM2FmeFpvcFVxNUJXY0NsVVhKeEMrTlJU?=
 =?utf-8?B?OWVKaXhQQmh3YUhrSXFFZS85dDI0dGJLZlA3TC9OcmtUWGxXSmgrZXdXeVNk?=
 =?utf-8?B?UlFobHpCNUdvSmVEYUdGYVU0KzFiSVR4Zi9MWHRSQUtZUUVic1kvZ1ErRUtr?=
 =?utf-8?B?UzRNVHFiZmNzSlJEZ2piSEE4RmVDeTI1YlhYV0ZUVlplMnhIYTQybTJOUDk2?=
 =?utf-8?B?MWxvWmlsOXZ2MGU4SXFNQjhOM2oxT1J0cDF6cG5tcGY5MHo5VEtpcHVoRk1O?=
 =?utf-8?B?L3lKeFlHeElKaDR4WnJmUHh0Qi9RZEx1ZGdDL2hZSnBZTHJMY3ZSaWJ1VGRF?=
 =?utf-8?B?eWdmc1RSaHlONmdHMDdSdi95YmxDZ28xb0F6c1JlS2ppYVBzaHh3Q25Hb3VY?=
 =?utf-8?B?NFJNdGtFZHU4RDNoWjh1aUxNYUFJU2R0V0p2SVBORU9aby9Yclo0K0w3SXNn?=
 =?utf-8?B?UEpURFZmNjNtV0doMjJnOGNCSkFUamdPdmx0blZwR0FUU2RmVTdORHpyN0tk?=
 =?utf-8?B?YmZERFM5S2hOcDdsSGw2TlMraGE2M0ZONUFEUHp1R3RoSlBhZ25QVUx3VEgx?=
 =?utf-8?B?a3U5a1BsQWorMkVPQm9xYXhOYjFRMGlQRjR2UUhBMFpTNTZiTnkrVXZWblV2?=
 =?utf-8?B?cG4va1F4N1k4RGNaWEV0bk5NQXpFOGpkcThzWDZnQXdlRXJyMkZGUE1XSDlN?=
 =?utf-8?B?OUhLTVEyT3g2cm9uVjRzSkhHdUplRDhVMnlEdnNNd2RwaEhSTTlpYytnTWJG?=
 =?utf-8?B?Q1RRa0ZJTHNWc3lKMWRyVVVVZWd6bjlGbm1KQkZkVTNjMXV2TGNjNm94VEt4?=
 =?utf-8?B?WHQvYVNQN1pLd2xZNUNpSGZKS2VCZjB4ZlFFZ2lMem8wVTRvYXFoVTVQV1RY?=
 =?utf-8?B?K3dLSXNGbmh0d3U2Sit4Z05LaHNtVEQ2cmo0TlZCRnd3ZURSY0pCYnhneENy?=
 =?utf-8?B?S0k0dHVwVmEvcmNIOUI1T3VIYkl3QXdDVGlTWGNlOWYyalFNa0lUR1ZrY3BC?=
 =?utf-8?B?VkFPazNzYm01ZVp2bnV2enZNT1lMVExTSmgraHhuYkE2YnR3RnJZa2JsTG9N?=
 =?utf-8?B?QTBueTRleEEyZFYyYlNBbkV0akxrZ1NsMHZseWxlL3h2YmVjMzdqWjlFeVhq?=
 =?utf-8?B?VGRmY2RUN3BNRVczd2xNelo0R01qSDhqdGZQSW1ESXd6SWFsOTJaOU1mRThG?=
 =?utf-8?B?aWZuRmd3WlhpSVVTQ2JOMzVnS1ZzWXJHNXMwL1ZMR2hjKzNZWmo5S2hHNHNZ?=
 =?utf-8?B?SWc5YVgrNmIyWXZWSkNMclFVaFRBRHZaTDQyNFEzUkk3VjE1TUM1dmRRRHYw?=
 =?utf-8?B?R3JLVFQxRW9wUFplNEFiaVB2RmpsYzlaUUhneGFoZ3pmcHc5OGJNd21CWEJK?=
 =?utf-8?B?MkNaeHo1UU5iOW5QL3ZIeGl2UitZYUpJSGErN2pub016Yzd4VFRCc1RDQ2xU?=
 =?utf-8?B?THY2Q3NUMjV5RlJYU21VSHI5Y1BuVGpCY1pURXNYR1g5N1hJNU5jVEl1MGFo?=
 =?utf-8?B?N2trcno5NkhrTkl3ellSMnhvb0xqNFZzS1MvSkFHTUJFMGJTS3YrTGhiV24v?=
 =?utf-8?B?SVdUOU9yNy90eUxVMzAxd3VZU2M3Z1pJYm9PZ1dVTzJhTlhJbEhBSnBtR0lV?=
 =?utf-8?B?UkhDZTdlYnN0R0ptdDM4T1RJL3pxeWlad28wQm9TK3g0RC9WaDA1YjhTY3N3?=
 =?utf-8?B?R3owRFpqYXpIYmEvcEcxYUVuOE9Bd2Mwbk11RDArbXhIOGZ0a1pZYTJSRHZV?=
 =?utf-8?B?a2dsRXphT3Boa09vY3hSN21sWUd6Z1dSdGw3MURRZEpxazIxV0Z2b2Q2d2hI?=
 =?utf-8?B?MUJjdzhjaitldGpwN25qamlSZkVWdytWOEhEOUVndzhHQXJYODdUUGJZUGE0?=
 =?utf-8?B?c25qZUpJVEUzQ3ZRM0VwNHJlYXhodSt4STRSOTc2bXRXWGhIdUF2Yk1XVk56?=
 =?utf-8?B?Q0UzejBoYWVyaEloUWphZlQ1NGowV1JmejIyMzg1L0g0TG1lWk5VUUNmdDA2?=
 =?utf-8?B?MlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?WStLNmdFNkl1bWhCcmJDTDZpbEJveWVnRWlDN2kxMjkyUlcrYXVIUnppUjJP?=
 =?utf-8?B?a1VGUGhReDNRbVVpTGhGRTJ3UkFoSkJoNTVML0doaHljMWt3RzRXMzFYUk11?=
 =?utf-8?B?UDRUMWxsZHhjd0QzMDFzcm9hNDBTcE9PM3c3WGFMaWJZRE1pcXpEV3NOZFV3?=
 =?utf-8?B?L3lVWkFoRVE4OTEvaldjeWRrcUhkNVpsa2pYejFYdW9YNFRLREpPQzRyUTd3?=
 =?utf-8?B?SHNJU2ZHN1pCVG8vWE50UVRxS2QxaDIxS3JQbVN0UjJ3dWpQa2NoT1Z0Undl?=
 =?utf-8?B?b0s3L29pVTh6d3pUQXdDY1BvcGRJR1JaMlV2UTl1azlXaWE3bVJOQW5RZzBQ?=
 =?utf-8?B?aEFhS1lySERTNUlycDNQT2VuN2JNbytlQVUwbVpTamRrSFI3bmlVVTEzRFNm?=
 =?utf-8?B?TGoxQ1JPaHlocjRISDlUK3g5ZkFoYUJqNG4zK0toOWFrMG5sN0E2eUt2eUky?=
 =?utf-8?B?QlpDTktMMEF6THVNS2s1VnVvS0h4akQ1SXFDVXhwUEx5bm5jOU52a2g4U3Q0?=
 =?utf-8?B?MEN1M1V1dmdJeXdjbGtKc0hQaThBTkpMdlR4N0c1MmtxOXA2MXJveFZvU3lq?=
 =?utf-8?B?NHM3UmRLZEI0SVNCNmNjNmpDdXE1QmMxbzRsaTBReVlMb0RLeTBleUxGdlBs?=
 =?utf-8?B?MU9ZZFJ1Q3BrNE84QnZVbEFHK2pINkx5K0Z0ajU2OUovdWdYT1l4azRsdlhl?=
 =?utf-8?B?ZEFGQ3lHWUZIdFdxc2pRLzJjR1V6eklNVmZjcUo5VUVJOUFzRXlSQStKcGt3?=
 =?utf-8?B?TXZEcW5CODg3T0t6ZlR4MFM1Uk1QQW12WDl4SXBvaDR5OGpsVXh1c2Y5djVQ?=
 =?utf-8?B?all1eHlBWCtYRW50QXNKNUd2YVZEWmphb2ZoUGk4Rks5ZUFaNlpodlZTeU5L?=
 =?utf-8?B?WXRUdEVuQ0U3b3AyY3E1WjVYZWRwT2J5OHFtK011UDNvRmJTMU1KNUx1SERq?=
 =?utf-8?B?Y2FNQzVhK2M1VXJocGhzc2czV3hDdHIrNE1OSnBwK1NEVXBTZ2tUTlBFOGhv?=
 =?utf-8?B?T085dGRDVTZNMnVPNExHV3N2RExsWjV5Mlk0VDAxN0FJazZadktLRUtLYTkx?=
 =?utf-8?B?SEtJUEFLNHUwcE50UXdvdHlLWHhuWXRaQ0krdjMyeUJTU2l5RGpsYXovS1NT?=
 =?utf-8?B?Q2YydmdHODg3ZU5ka3dNNHBtUVlkM2VwVkR2N3h4TWR1bmtIM1YrTnYyVlN6?=
 =?utf-8?B?OUlkREYweGh3RzNMRktKclBCckludDQxK2JFZzh0NjlJWTMySkppY1d5OG5C?=
 =?utf-8?B?Y1VDUEhXQWt6SlNRZHlBMFc5RmtNdU51WEEyUE80cHNsNEpBejIvT2VqYnk4?=
 =?utf-8?B?eUc2elRJS2duTFZhUDN2dlZvdUt0NVQyMTl5TGpYNXkzVWtLbFh5WGxVRnNH?=
 =?utf-8?B?MDVUUllDaDd0L1I1NVYzNGJDZk9OdFJjTnVjRS85SmlXbk9CdFZ3UEE0TjVm?=
 =?utf-8?B?YjQ4UVdpU2EzYW9oS2lyNHBIcFFJcEN6Vm9JTHd3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1b0c557-e857-46ae-43b9-08dbd3e581e4
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 16:31:28.4852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ghU3BUDM0sLlb5C7VFM0h2kXLq8P9Jd1cFXW1m/ZSRyOGaOWpqRb/HT8/F85MyJxvur5O51hW7FxIguPYv9Xx/VAGonPjSH+M1TGCyimLXU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4598
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-23_15,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310230144
X-Proofpoint-ORIG-GUID: SQV-b8y8jU3GJIOaf_ItBHa5xjSW2Z5k
X-Proofpoint-GUID: SQV-b8y8jU3GJIOaf_ItBHa5xjSW2Z5k
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/10/2023 17:16, Jason Gunthorpe wrote:
> On Mon, Oct 23, 2023 at 04:56:01PM +0100, Joao Martins wrote:
>> On 23/10/2023 13:41, Arnd Bergmann wrote:
>>> On Mon, Oct 23, 2023, at 14:10, Jason Gunthorpe wrote:
>>>> On Mon, Oct 23, 2023 at 10:28:13AM +0100, Joao Martins wrote:
>>>>>> so it's probably
>>>>>> best to add a range check plus type cast, rather than an
>>>>>> expensive div_u64() here.
>>>>>
>>>>> OK
>>>>
>>>> Just keep it simple, we don't need to optimize for 32 bit. div_u64
>>>> will make the compiler happy.
>>>
>>> Fair enough. FWIW, I tried adding just the range check to see
>>> if that would make the compiler turn it into a 32-bit division,
>>> but that didn't work.
>>>
>>> Some type of range check might still be good to have for
>>> unrelated reasons.
>>
>> I can reproduce the arm32 build problem and I'm applying this diff below to this
>> patch to fix it. It essentially moves all the checks to
>> iommufd_check_iova_range(), including range-check and adding div_u64.
>>
>> Additionally, perhaps should also move the iommufd_check_iova_range() invocation
>> via io_pagetable.c code rather than hw-pagetable code? It seems to make more
>> sense as there's nothing hw-pagetable specific that needs to be in here.
> 
> Don't you need the IOAS though?
> 
No, for these checks I only need the iopt, which I already pass into
iopt_read_and_clear_dirty_data(). Everything can really be placed in the later.

> Write it like this:
> 
> int iommufd_check_iova_range(struct iommufd_ioas *ioas,
> 			     struct iommu_hwpt_get_dirty_bitmap *bitmap)
> {
> 	size_t iommu_pgsize = ioas->iopt.iova_alignment;
> 	u64 last_iova;
> 
> 	if (check_add_overflow(bitmap->iova, bitmap->length - 1, &last_iova))
> 		return -EOVERFLOW;
> 
> 	if (bitmap->iova > ULONG_MAX || last_iova > ULONG_MAX)
> 		return -EOVERFLOW;
> 
> 	if ((bitmap->iova & (iommu_pgsize - 1)) ||
> 	    ((last_iova + 1) & (iommu_pgsize - 1)))
> 		return -EINVAL;
> 	return 0;
> }
> 
> And if 0 should really be rejected then check iova == last_iova

It should; Perhaps extending the above and replicate that second the ::page_size
alignment check is important as it's what's used by the bitmap e.g.

int iommufd_check_iova_range(struct iommufd_ioas *ioas,
 			     struct iommu_hwpt_get_dirty_bitmap *bitmap)
{
 	size_t iommu_pgsize = ioas->iopt.iova_alignment;
 	u64 last_iova;

 	if (check_add_overflow(bitmap->iova, bitmap->length - 1, &last_iova))
 		return -EOVERFLOW;

 	if (bitmap->iova > ULONG_MAX || last_iova > ULONG_MAX)
 		return -EOVERFLOW;

 	if ((bitmap->iova & (iommu_pgsize - 1)) ||
 	    ((last_iova + 1) & (iommu_pgsize - 1)))
 		return -EINVAL;

 	if ((bitmap->iova & (bitmap->page_size - 1)) ||
 	    ((last_iova + 1) & (bitmap->page_size - 1)))
 		return -EINVAL;

 	return 0;
}
