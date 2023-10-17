Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5B97CC5A6
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 16:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343606AbjJQOMm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 10:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344031AbjJQOMk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 10:12:40 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CABFC
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 07:12:38 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39HE5YPA011625;
        Tue, 17 Oct 2023 14:11:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=in4kPD+0QyicganiyvHbkpwWKKwdndCaW87v97vKmPE=;
 b=vMqxDAgGa55tPSAlxjKloV+B/65xP2P/eLGQw/VDjNDE+0e36Xc6QayvShGicjfBwk8P
 +KoPc/JrhHah8tmlunLCtU8S7otvbXTyhsvG6lrZZJ0fmA8dxcs/OlKR9fn5wt3Szc1Q
 1p7gvBwH7kF8onc42Qt4HNe/1NYzH0HyZlOe9jUcmvEEHBDs3gJNgQby3oZPso9CP2jw
 yWS/0tdy+Q8gV0IPUoo+HzATzVPc+IE1hqBUcD3pBjv2rVcoG5Eq24cv5nSvlUminLvn
 SgyDDv2t3aESJ395jlWIxaLzA8H4WaN/UMAobfXKpPHvfjEa1Gfa3oe7EkciwFWLxOnO ag== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk1cda6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 14:11:55 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39HEBBQD015370;
        Tue, 17 Oct 2023 14:11:55 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg1f3hsf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 14:11:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JmOAk9/3mUi3d8fkGdgqcWzV80QTN2k4lDGeIfV6IxHmMdrBksIhbrPWs8F7o33ePoZgQ/co2+V40lI+EbGUVBOXe1q2Aw8cuxGMhvSucRc/W3FS3PuuE2V98TLiWeMCyzoH1YYsoyvkqqCB/WhSoWwwH51VanCtsvWA+KnuurhcQNaDi/PiuJq01Pw41NxSSvL6TYEpFiXQAIozNiOKnKNEeeY7D9mAOsU8YK8zEj3W8VhPvR5Z8Mjbpa/IlMcUwZHTpuO5s+zAfST9gYhMM82wvFxy9OEoV48ta9JrgaL2TdiaFKYxHtzWxk+R3fNQwMB5QkBCoIOBr0Tq1U+Itg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=in4kPD+0QyicganiyvHbkpwWKKwdndCaW87v97vKmPE=;
 b=AvxwUwHZCZK+MKBFd+gUzIiVcbscCgGycdKn5tSzfh+r/jGzFffAJrHH0048NaEfjSRY7wk3P48m0IsRf2aQ8CyjcA1j/IqoV0uAUddfpIWdy1E6hbJECaxFJDjoYbmLrGdka8vXaGxzUJ2dOmwVAGHle3gBJBa4eS//SpC5Qya+XXnzMy+rE87hDNL+rWMY6zlPihZJ3nHXSl2j/WTz1c1fcQazuS/s3sixivr+6DUG6hoVTBbKDnhQVQqSxioBGXop+E0GMbHxs+rG+CR8HVvSfwqHn0eN/yajjPeRcZM8ssUy4KeJokA0UA5cy9DRNqpiB5wxf/qRAMWnVJ4dYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=in4kPD+0QyicganiyvHbkpwWKKwdndCaW87v97vKmPE=;
 b=ZsuRlg8XHpkvuM7Mm7+2PC89DBk2CKz/3xEXDbSbB3yIPz4MunWVTbl8fl58lc/z0MCcI7IiVflCg6XjjNJoMwSC70X90zEX3aKgNedQD3Chz7Agu2yfA+oDkTmYCFlsSmOI0jm/PB+QLYrjIaNR0mWsT7aB2mzsyl+yzhJ7vac=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CH0PR10MB4892.namprd10.prod.outlook.com (2603:10b6:610:dd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Tue, 17 Oct
 2023 14:11:52 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6886.038; Tue, 17 Oct 2023
 14:11:52 +0000
Message-ID: <832449ab-1704-43a0-828c-5b6eba2b84af@oracle.com>
Date:   Tue, 17 Oct 2023 15:11:46 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 19/19] iommu/intel: Access/Dirty bit support for SL
 domains
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Baolu Lu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-20-joao.m.martins@oracle.com>
 <d8553024-b880-42db-9f1f-8d2d3591469c@linux.intel.com>
 <83f9e278-8249-4f10-8542-031260d43c4c@oracle.com>
 <10bb7484-baaf-4d32-b40d-790f56267489@oracle.com>
 <a83cb9a7-88de-41af-8ef0-1e739eab12c2@linux.intel.com>
 <e797b35b-6a17-4114-a886-95e6402ad03c@oracle.com>
 <20231017131003.GZ3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231017131003.GZ3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0285.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:38f::19) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|CH0PR10MB4892:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ba16ac0-a0b9-4edb-6fef-08dbcf1b02fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WoHIAewpv/RXNORgAcW6d50hDnZUr2zR7isNSxgAq507VdbSEWBt8iR8iPbc+1U7N1QDPdSAN2W0HnVtGuqoaD6df6Angm02SrTZFLg1m/hbgglc2vxLQvxcYmvUZa1y/7nih8RKsYPbkqGdMKb8f8+2RxUtNsxVy/lr9ajq5Wklb5Wsl+89iP66iBeLQQWz/XeoV0Kqr0nWIVPtAGy2y68Df5BcyI8AaztIjAE0jG2GQK7tLgkWKyASodjhgxcMG2gOspj3mJI6KbsHCvqRKBgB6l5YA6t0JHFx/Iq9v2pRJQ6csMAmdFceKb2ampmHO6RF8/tpsUacCR5LfqFY5aEupQh+2Rf0+kucamkBZMikWOuRgPzFILivoWsk3mdynsJwNiwEamUFY9cuWYoUc5puN6H7RwznHIv5I07L9HROhAQ4/9jZlkHaSYqkNpkuNvPWSzYQHvzGIRfTEEeLd2X5LkJeZEwM+NYchin2ZIyjaBB3chP47cTnSWc6fksr6mY3PiAKO9wF3bkKPNKeEJMLWKx499Tr2EQYNdet9pJmCEmRlIb0PZz3i3WhOtM5yMNCDhcGRsaV/LiyAvdXIhQookGnkzVn1Ux4aYAxPfIoJmsNS0GOpvSl/o9/O4GVuN2hqs8O4/YACUGRB905KWn/Fw2cCwsAmxanpo+X4/w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(366004)(396003)(39860400002)(346002)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(31686004)(54906003)(66946007)(478600001)(6486002)(66556008)(6666004)(66476007)(6916009)(316002)(83380400001)(86362001)(31696002)(38100700002)(6512007)(26005)(53546011)(2616005)(6506007)(36756003)(41300700001)(5660300002)(8936002)(8676002)(4326008)(2906002)(7416002)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MC9sb0dDM2pGU1k4cVl4MjZMa0VZTVl4TFR1eEJzY0JBVGxGdmxZU1l1VDVl?=
 =?utf-8?B?QzBVM3ppbzlsSU5LZHd1andWVVhIS1QzTnBNUHp2ckpJUEtscmlKYzhxWUNV?=
 =?utf-8?B?YXlselptVk1qa0ZaWDlvcldRTzY1U3VuVHdXbnJIRGIrWllaUVplS0hRQ1Jv?=
 =?utf-8?B?VXNTU05oQzRSblZoWGdVaTc4UTN1ZUlzNWZJOUpaejh2REFQaGpDeFNaQi95?=
 =?utf-8?B?Rkp5SGF5MGYranhiOUFwZ05Xc1ZldEM4NnFHTm5RcGdmMHpiakpPRVBjdjg2?=
 =?utf-8?B?NzlhbjdpdStiUzRtWGtyQTczRnJNck5WLzhsVFplOTJJTmhBcER3bmtvTGN6?=
 =?utf-8?B?eE1mcVFPb3doRWhTbEp4TE5qaU5DNXZCdWR5cVFxTXpITHk4THJ0YjNZOFo3?=
 =?utf-8?B?Y1lDVFhNSDJMc2o0cklqTXJQMG9XOEhVT1VadHRZZ0xTWjVkM3IvUDVzbm5N?=
 =?utf-8?B?c1lET3dLTzVwVTR3NVFlODlGWFlvNnVHL0VrNmpGU1BNQTFGalNKUmVYNklz?=
 =?utf-8?B?VmYyUm9HY1k2WTVwczhKa21aYlRFWXJHSjM5OE1kZzlSOTk1K1FqN2kxcmJh?=
 =?utf-8?B?M2g5QWw0LzBQZU11UjdaajlSTk5mL0FQUjBNcVNPT2o0Yzhmd3N3QUgyOVRo?=
 =?utf-8?B?SU1ub29RS0xsRGxaQ0gwaUd2NlZvUTRXRTlnWmRaM0hhWHhVSGo0MVluZ1lX?=
 =?utf-8?B?MUVxRUVod0pybDhTR0Q5bjhrY3Fkb2VKQmR2d056MzYwaVcwcHRPNDRRb0ov?=
 =?utf-8?B?bnh6UjdpZmJUZVNiTWttUFR2d21FTTlNV201bDljNzRvODExS3JZK2cvNlBz?=
 =?utf-8?B?OFd1Yzc0VlMxYm1pbGdnYm4zNFc0MzRYVXJ4RlpZU2x5UThMcUdoTk9jT3BP?=
 =?utf-8?B?UitZUVRzUUlJM0J1SUxscmlwVDBuZ1pWRlVZQTNmSG5aVU43eGNpVmNQeTdT?=
 =?utf-8?B?US9WbThLOXFQRnBjOURSYkFrUmpsVG5pVDJRVndsaG9QelZxSUFoNkFJZE9x?=
 =?utf-8?B?c2xHTzIrTlRzVzkzNHJjOU1tdlpkSTk0Tlc3UjE1cXd6bTQ1WTJMRm02cGk2?=
 =?utf-8?B?dEgzSTBzRlB2eENUMlVtTUk2VG1tWTVDZHNkMUR1SG9INW41US9JSEhUc0w1?=
 =?utf-8?B?aldCblpCOFVXeGFWTkxnaG5nb0dHeGFjZnF3RFpGeUF1Mm0ySW11Z2QzeURl?=
 =?utf-8?B?OHJTVldlRmdGWllnTDBqRS9MUkVTa2p2bTJ2YXBPNDJyR2RpUWVENklUbmhM?=
 =?utf-8?B?SUk0b2pjSWcwbk03UnNXMldzLzdJdk1HUFdkbURzZE9KUXV3U3E4WHhvUjhV?=
 =?utf-8?B?clZQVEt2VkkzV3Y2MmJGTVlZNmtPYkNzLzh0R0ttanVpcTBqYy9sUjZ6YTJQ?=
 =?utf-8?B?eGpJYVBmSk9sNE5BMG9VNnRqKzlEcjVkbkwwQ0hVZmxqcE1pWWNheXRGcElT?=
 =?utf-8?B?MjBwdU9MZHJpTWJ5amwwVmNDdkVQa0ZZY3NOSVMyUmNRT3JHZ1BKSGRtdTgw?=
 =?utf-8?B?dU4yOTQxSDV5MklCMjJaVHFlNUx4c3BXZzgvVE9HNDZ3NlA3YXFKeFlmSXdJ?=
 =?utf-8?B?TWRzaGE5NkQyaXBJNlBVbi83bERwcVp0ZzdlNU5GM0VqWTgxQWlnQ2MrdEFG?=
 =?utf-8?B?bElpNm95eEprY2ZVcW9ZQldHMkNNbzY1cFVSaGtWbXQvSTVhSDR2M2oxbjcy?=
 =?utf-8?B?cUlvOHdJVndPRkZueGxXaFVYbkMwejJJK29WTmlrb1BNMGxwdkxhWlVyU3JQ?=
 =?utf-8?B?UW1zTVhIUElSQWdWMEt6Y2p4UFlWMDhTWmFtWmFScUpPK045YUF2Z0F5a21n?=
 =?utf-8?B?bWFmUElLZDRQb0l0cW10RlJ2VlFMUnVWVzJHYUxjYjRLUlJVc200dm93cWNx?=
 =?utf-8?B?NzF2NTcvSW9TN05ELytZa1FNUE1xV3J2SkhVZEN0SE1tZU1MYThNK3ZpQlVj?=
 =?utf-8?B?SkI1Z2pHQjN1UEU5NFRhTDFhZkI2QUN5S1BBdkR0d2dGakp2RDMzMWplWU44?=
 =?utf-8?B?N1I3NG13M0hKSWQzWVkxQXBCQ2pjRi9VL2VDcnZRWC94NU53eGVXQ0RmVUN2?=
 =?utf-8?B?RmpXNkNweTZFYk5sQkQvbDZDVEhhLzU1SDN1V21GUTlQVkRIbjFURzNLc1E0?=
 =?utf-8?B?MWdYOTQ5eWVJa2J6VW1XaTJwV3oyVHlZYjljRlpDYldCUk9TVWlQa0dIU3ZG?=
 =?utf-8?B?K2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?bC9pYkFybjNoemFUTzJ2YWRQWVdPRnVNNW00WnRXWW93SEgvbTFlU2NmUlZN?=
 =?utf-8?B?dzRkMFNiYklBQ3lrR0NuUldlWEdpQi9qWGxoZ2NBdFd5NlBqUHRrSUV1cFAr?=
 =?utf-8?B?M3NRT2k3eDBXWE9TUG9qU0tmOEpWVzNkUE1jWWMyUGU3UFE5N2NCcm1wbDVC?=
 =?utf-8?B?SVN3VVArZTdDbVlkSldacWhtM2trbEo5a0lVODBkZ1U5YmRWU2JyYUpYL2NJ?=
 =?utf-8?B?N2xxRlJXMFprWVJHNmV5TThmNGQxWHlpMWpMdUE0NUkyVkJ4UUJFZmFJUFgv?=
 =?utf-8?B?S0FtbXhkUkQvRVhXbEhiK2o4dUszVkpZQUxLV1RUd0lIc2FiazV5WG1XTE9a?=
 =?utf-8?B?eEF6ZXNxRmJ2c0JxQTFLZTc3RWxudXhPS1Y1aVduZUJJSnUrWjFQZDNySGJv?=
 =?utf-8?B?L3VxcU41TDFTd28yVjhkUlg3ZTFKb2p4aGs0d09MMlBWUXEyRXlRRnNwdmtU?=
 =?utf-8?B?R3BhNFBSZjJ6WDhDVkZuNkxRRSt2ZlJvbEpHNE9xTmJ3YWVRVkdjemFEVDYy?=
 =?utf-8?B?MFl0K3VnMXNLVXJKaG5CeXIzWG4ydklzMTFWOGlyV0o3K3ZwUjExRkRvSXJY?=
 =?utf-8?B?N3VjNnVFVlBKUzFEVENRNTRwN0xjM2ozOC94RTFVRjdOZ0RaMVYva1M2Ty9S?=
 =?utf-8?B?T3VpdWtvYjJmeWlvdW82Um1IaDlJMjhtZmdpL0h4azZYNFd4OFRWTW5QRC9Q?=
 =?utf-8?B?WU9ERzR0aXREUDdOdGYweGUzdzl3L0M2dXEzWjRjZTJ2ZmlQVWE3V3NROFVa?=
 =?utf-8?B?dEtyTmowd1BraW1CVnd0K2E2MURTRUtTL3NiU1lDWjNFTFR5VXVNcEtaQjlo?=
 =?utf-8?B?dXptbEliN2pBOVQ3SG1LVzBYQ21kNXFDNlQ0SDVBamlKaW5RbEUyeGdoc3NZ?=
 =?utf-8?B?dDRDR2xEUFhFTlpENU5nanZPMVYzOGpXNi85dmN0VEtsTkE0Q1pLZzlRdXZx?=
 =?utf-8?B?OUpTeDNrcDBqZEFKNGovWEgxRS80K0I0VGdZUmI5WWlmdlBSeExmTnd4dG41?=
 =?utf-8?B?endFNkorU2RUNVBQU1NrNFdHWnBzVHJWc0YxcmJnMTkwWVVOY3ZkWnI3SGp2?=
 =?utf-8?B?cFVxQ0J4blhUWVFUci9iYVExdVVIMUJVMmNCTVhvTFF4SzFIaUk5ZlBHS3Nz?=
 =?utf-8?B?TzRONHVHeHZyM3VZNkdPaEN6Q1Nrc1pJMHVPbmhCSVQvN2h3Rkh3UWNmV3VB?=
 =?utf-8?B?Nkg5ZUtyK1p2NnlkeWFZZTFrUTlpVG96RndMVXJJbU1YWEFRR1hJb3U0WldT?=
 =?utf-8?B?dnBNYVhxREJ5L0F2OTVpMGltKy9iNkdrVm0yRFpkaE54U2NFWkZROWF4bWhj?=
 =?utf-8?B?UGxyV29mYU5NQmk0ZHdvUzRDTWRHTys4Tk0xeEsxWXgzcDRuMi9mZVY1T0t5?=
 =?utf-8?B?cDloaGpuSU92S2RDQkNIdXAyOWZjQXZyZXA4bTc1cUVhbXJ2VnhmMkhJaXVl?=
 =?utf-8?Q?pxwgjVq7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ba16ac0-a0b9-4edb-6fef-08dbcf1b02fc
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 14:11:52.6067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hmc+CoQk6yOqZ2HbAOkFvFZeRVNhFQ7v2LOcy6PQXMkO+lXcU+/TPCqhbzNi0TMHCXoBvGtnYVqfW0dJWKEmB1yLjIhPTo/wWECJz0YkyX0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4892
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-17_03,2023-10-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310170120
X-Proofpoint-ORIG-GUID: ObuDUmKPjIbSuN1yk0ntIFC9gFdd7_8W
X-Proofpoint-GUID: ObuDUmKPjIbSuN1yk0ntIFC9gFdd7_8W
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/10/2023 14:10, Jason Gunthorpe wrote:
> On Tue, Oct 17, 2023 at 12:22:34PM +0100, Joao Martins wrote:
>> On 17/10/2023 03:08, Baolu Lu wrote:
>>> On 10/17/23 12:00 AM, Joao Martins wrote:
>>>>>> The iommu_dirty_bitmap is defined in iommu core. The iommu driver has no
>>>>>> need to understand it and check its member anyway.
>>>>>>
>>>>> (...) The iommu driver has no need to understand it. iommu_dirty_bitmap_record()
>>>>> already makes those checks in case there's no iova_bitmap to set bits to.
>>>>>
>>>> This is all true but the reason I am checking iommu_dirty_bitmap::bitmap is to
>>>> essentially not record anything in the iova bitmap and just clear the dirty bits
>>>> from the IOPTEs, all when dirty tracking is technically disabled. This is done
>>>> internally only when starting dirty tracking, and thus to ensure that we cleanup
>>>> all dirty bits before we enable dirty tracking to have a consistent snapshot as
>>>> opposed to inheriting dirties from the past.
>>>
>>> It's okay since it serves a functional purpose. Can you please add some
>>> comments around the code to explain the rationale.
>>>
>>
>> I added this comment below:
>>
>> +       /*
>> +        * IOMMUFD core calls into a dirty tracking disabled domain without an
>> +        * IOVA bitmap set in order to clean dirty bits in all PTEs that might
>> +        * have occured when we stopped dirty tracking. This ensures that we
>> +        * never inherit dirtied bits from a previous cycle.
>> +        */
>>
>> Also fixed an issue where I could theoretically clear the bit with
>> IOMMU_NO_CLEAR. Essentially passed the read_and_clear_dirty flags and let
>> dma_sl_pte_test_and_clear_dirty() to test and test-and-clear, similar to AMD:
> 
> How does all this work, does this leak into the uapi? 

UAPI is only ever expected to collect/clear dirty bits while dirty tracking is
enabled. And it requires valid bitmaps before it gets to the IOMMU driver.

The above where I pass no dirty::bitmap (but with an iotlb_gather) is internal
usage only. Open to alternatives if this is prone to audit errors e.g. 1) via
the iommu_dirty_bitmap structure, where I add one field which if true then
iommufd core is able to call into iommu driver on a "clear IOPTE" manner or 2)
via the ::flags ... the thing is that ::flags values is UAPI, so it feels weird
to use these flags for internal purposes.

With respect to IOMMU_NO_CLEAR that is UAPI (a flag in read-and-clear) where the
user fetches bits, but does want to clear the hw IOPTE dirty bit (to avoid the
TLB flush).

> Why would we
> want to not clear the dirty bits upon enable/disable if dirty
> tracking? 

For the unmap-and-read-dirty case. Where you unmap, and want to get the dirty
bits, but you don't care to clear them as you will be unmapping. But my comment
above is not about that btw. It is just my broken check where either I test for
dirty or test-and-clear. That's it.

> I can understand that the driver needs help from the caller
> due to the externalized locking, but do we leak this into the userspace?

AFAICT no for the first. The IOMMU_NO_CLEAR is UAPI. I take it you were talking
about the first.
