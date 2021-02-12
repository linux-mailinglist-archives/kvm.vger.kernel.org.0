Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC87319C8C
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 11:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbhBLKTV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 05:19:21 -0500
Received: from mail-db8eur05on2056.outbound.protection.outlook.com ([40.107.20.56]:58368
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230486AbhBLKTH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 05:19:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pa8nKtxZn8hFAaTBZsj3WR27nA+is46V5zQmG51N+xw=;
 b=dA+0J71kh4u3wpZXmltxcONGeujLABdBSDWR8sLdGrLqfQqs05G4gxF/HRaMMxMSQ9GS9veKSBBZIYmXvrBT0xqKCRLteCYa1Q2xD8rlR1lJo5C9M2rDr44S7UO0B2vOe5OhfTde8NaRXbsSzRTTl+w9bzTO/fO/kU/eDEMi17Q=
Received: from AM9P191CA0001.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21c::6)
 by VI1PR08MB4063.eurprd08.prod.outlook.com (2603:10a6:803:e8::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Fri, 12 Feb
 2021 10:18:17 +0000
Received: from AM5EUR03FT006.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:21c:cafe::47) by AM9P191CA0001.outlook.office365.com
 (2603:10a6:20b:21c::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.28 via Frontend
 Transport; Fri, 12 Feb 2021 10:18:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT006.mail.protection.outlook.com (10.152.16.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3846.25 via Frontend Transport; Fri, 12 Feb 2021 10:18:16 +0000
Received: ("Tessian outbound af289585f0f4:v71"); Fri, 12 Feb 2021 10:18:16 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: fb035c4c1db6b764
X-CR-MTA-TID: 64aa7808
Received: from 5976346a1a89.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id E08BDC85-762A-452F-898C-66E0A42570FB.1;
        Fri, 12 Feb 2021 10:18:10 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 5976346a1a89.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 12 Feb 2021 10:18:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kwNexPvpjPIinrKLCnBpg/qYemHAMOnvcJh6NKb7wTme89v2K1L0lG0o/m7SZlnER1zLfPM3UTlnuEoUSAzCaIY+Y9dvg0aRbaRe271IlbIEiwXmkVoFbdrclNsoUHe47snc8DTG9/v0fjt4+A3jmcuGKCtcSnbzX7zDo2sq89F/wJQAzWWR3hAkFQ4rWm+gJsAb3CETUUf7sk1GleKegrkpV1hDqFAnhveaM6j//WskMx6vRnxn2LweEFQTaC9ZlzgehY8O9XBSPTGF3SyKdXgdeutqr/dmPjyCt5HwF/Aae7QxdtMw7EiXIEvv0wZCEY5ijKCdQmbJnJYtzKSRug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pa8nKtxZn8hFAaTBZsj3WR27nA+is46V5zQmG51N+xw=;
 b=chqt2vTFLpG7/y37CnwKCafg0FqJ1RaZOb9JHOaMzNzTThPiI+wKYMj245Lo00m6lCg+uC0Ku8jvd161HpZ3bX96yu8VvQ/ACYZtiZW2+3dYlhWWFuXRPg1R4XvoD9xvODKTzwm67AB/y6lenQR/BFEez0Zv0T4I3rrwcFpiID+ICcj+wzPEgx0RVPQ1T60M2oEHCZV/rmbtd95bBtsE9QMcmnSGwqUEWD/SnFFs9yjYZF0VOuPfqoUgZRxzSycxSCjFSC45LOdpFz1LNpmu533tkgOJZ+ir4TH7TQn7EGRrFSKcGEbZluwjc5GUrnCWMJmzNVzvZnWIj75P6JP//Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pa8nKtxZn8hFAaTBZsj3WR27nA+is46V5zQmG51N+xw=;
 b=dA+0J71kh4u3wpZXmltxcONGeujLABdBSDWR8sLdGrLqfQqs05G4gxF/HRaMMxMSQ9GS9veKSBBZIYmXvrBT0xqKCRLteCYa1Q2xD8rlR1lJo5C9M2rDr44S7UO0B2vOe5OhfTde8NaRXbsSzRTTl+w9bzTO/fO/kU/eDEMi17Q=
Authentication-Results-Original: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=arm.com;
Received: from AM0PR08MB3268.eurprd08.prod.outlook.com (2603:10a6:208:65::26)
 by AM4PR08MB2882.eurprd08.prod.outlook.com (2603:10a6:205:c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.31; Fri, 12 Feb
 2021 10:18:09 +0000
Received: from AM0PR08MB3268.eurprd08.prod.outlook.com
 ([fe80::b55a:5a00:982b:a685]) by AM0PR08MB3268.eurprd08.prod.outlook.com
 ([fe80::b55a:5a00:982b:a685%6]) with mapi id 15.20.3846.028; Fri, 12 Feb 2021
 10:18:08 +0000
Subject: Re: [PATCH v7 02/16] iommu/smmu: Report empty domain nesting info
To:     Auger Eric <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>, "Wu, Hao" <hao.wu@intel.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
 <1599734733-6431-3-git-send-email-yi.l.liu@intel.com>
 <CAFp+6iFob_fy1cTgcEv0FOXBo70AEf3Z1UvXgPep62XXnLG9Gw@mail.gmail.com>
 <DM5PR11MB14356D5688CA7DC346AA32DBC3AA0@DM5PR11MB1435.namprd11.prod.outlook.com>
 <CAFp+6iEnh6Tce26F0RHYCrQfiHrkf-W3_tXpx+ysGiQz6AWpEw@mail.gmail.com>
 <DM5PR11MB1435D9ED79B2BE9C8F235428C3A90@DM5PR11MB1435.namprd11.prod.outlook.com>
 <6bcd5229-9cd3-a78c-ccb2-be92f2add373@redhat.com>
 <DM5PR11MB143531EA8BD997A18F0A7671C3BF9@DM5PR11MB1435.namprd11.prod.outlook.com>
 <CAFp+6iGZZ9fANN_0-NFb31kHfiytD5=vcsk1_Q8gp-_6L7xQVw@mail.gmail.com>
 <9b6d409b-266b-230a-800a-24b8e6b5cd09@redhat.com>
From:   Vivek Kumar Gautam <vivek.gautam@arm.com>
Message-ID: <306e7dd2-9eb2-0ca3-6a93-7c9aa0821ce9@arm.com>
Date:   Fri, 12 Feb 2021 15:48:00 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <9b6d409b-266b-230a-800a-24b8e6b5cd09@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [217.140.105.56]
X-ClientProxiedBy: PN1PR0101CA0015.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c00:e::25) To AM0PR08MB3268.eurprd08.prod.outlook.com
 (2603:10a6:208:65::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.162.16.71] (217.140.105.56) by PN1PR0101CA0015.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:e::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 10:18:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f614fec8-b042-4e0a-771b-08d8cf3f8377
X-MS-TrafficTypeDiagnostic: AM4PR08MB2882:|VI1PR08MB4063:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR08MB40634F6B845C02227E7BFB94898B9@VI1PR08MB4063.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: OSwBnga0wCJvs/DLQoJgmjw4cCRcIzhLdta/Iu5R3khAclST594rGq7hnGiAcMlZBQhLJcwDD4D/oGuP/jeduL0YNTAvQ87fF6c1myr/PslmKuBAYswTV1sNjxdpgWAjB++MgV98k/tHpnxbIJkMj1W53ee5/AtqItOEBLrU1wLA6zCdWxW1EfG1QdHN4CSo2Hj2Rc4TFlbeAbDzePf8NnCCApf60vm24XjKgFzsWZWqpgypwwrg+dGnSpZs3GhGjuI1JoaTappnSRazvcisOAPKiCml7n0cZ3kx7qpklI7X2l+4cXZOdSMrVSnrelpglFERA9O45B/JDec+GDF2au4LgxEFKkAPxk4QauLjBFur3rPy6SY6BGaSOQwkr4gOYzE1yk4slqSTzi55XB805rGv+4R0WqFItGNGb4eNTbmt1mus1qT1ieIXf3Y1H6FKVg9Jw6S/KmTSX+8vo2HwBJrvDsJJfF6mx+l8okT83ILdya4aTfaaBu/UGvh2FjEpzRruhTTfoxyZXMP9qAguKmaSgr4+DGWkamroZnjD0HJyV77H6f0+5B/5CYaQocjeQ69IoDjueKu8dxW8vARJtsB9lNWEIS/e59hYsuTczOs=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR08MB3268.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(31696002)(52116002)(6486002)(7416002)(5660300002)(6666004)(2616005)(316002)(31686004)(16576012)(956004)(2906002)(86362001)(110136005)(54906003)(478600001)(8936002)(53546011)(66556008)(66476007)(26005)(8676002)(186003)(4326008)(66946007)(16526019)(36756003)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Z1c4cjNwTkFIczFkM3hiNkZPckkyNURhUGNaYTV2TUV6ckFkOUZYNDFJN2s1?=
 =?utf-8?B?UDh0L3Brc2N6WXEzdHpseWJlUldWSzFoa1d3eXZIWkJPUE11ck93VEFNSklO?=
 =?utf-8?B?NFZ3eVEydWlrQnFQbkRMQ1I1RjkyNmtjOUEyWFI4ZUV3N1pKYmxjSEsveUhn?=
 =?utf-8?B?MHdwZ0hWYmh4Sk9vcWhzL0M0OXFrMWdTb3h5ODViQWd6YjVQNGtuZkNONFFC?=
 =?utf-8?B?TUZsMlVtMk1KdDdBcnBMdkRVUzdtS0VYMXBQcXpMNU95SUVpbGExcWxOUlRZ?=
 =?utf-8?B?TnRjSkJETUZjWktJM01YTXJqcFFSTVZRMzNYMmRyQUFsZkd4WTRJZzNtZGp6?=
 =?utf-8?B?UTR2RTFsT3lPakhwb252Y24wSzFKYVU3R3RGdGlHMmNXSzlIYlNmMzJtQ3NM?=
 =?utf-8?B?Z2oycmFwVnNlTGIxR3BUblFQMy9BTEg3RSsxc3B1Mzl2REdyQkdWcUE4SkxV?=
 =?utf-8?B?bU91ajJQN24yYUNFdFptY3QvaEUxYnhPazFJU2I4U0tuS3E5QzFhaURVdDlK?=
 =?utf-8?B?NHFBdXFwa0RMUnFXeW4yOGVDZG03bUlxT3Z0ZGhwVXhITkNkcFRlTGNkMXNt?=
 =?utf-8?B?U040T2xjTE9wS1YzbWNOSnNsQlNZV0paOE5UWWp1bGNzZnpZM2R6K1FsU3li?=
 =?utf-8?B?alhidVM5TTJTOXprRjl3Rzd5cC94d2o0L284OTdaUjBYK0d5bGZwbVJvQnND?=
 =?utf-8?B?MEswSlVEM09lQmdQek9UMEJxUVFFaitnQktMS085N1JkelZJRzN2TVpxcTRs?=
 =?utf-8?B?NDN3bWdES25Pdk9SdGp0bkxlOWsrSUpBK1VKNUdXVTFCL3N2SmJVaU02akFN?=
 =?utf-8?B?ZU1NZWpEZDdHNXhVQkNWTUlDZ2Z2Z2ZSU3kwZDg4N1BqMFdYanVPTkd4enlV?=
 =?utf-8?B?VzAwRy9nK3ZvR05JYTV1MXpjMVo3WDd3c0VqQmxVQUZXL2FrQXRSSUdDMjZ4?=
 =?utf-8?B?Q0NYdlJDZmpwYkplWm9ZTmRRaGlENks1SmdaKzkwOTFTWWYzS241ZE9vNHo1?=
 =?utf-8?B?TEtzL29QbDhvcUllZ3NjWTU2NGprZHV5L21jNDlOY0tzQ1JiSUM3eHBWNXdt?=
 =?utf-8?B?UVpuVmxuTjc5UE9oKzZjZlJ4Qy9IT2JEMUxzZFZDRXVYQ1VJeUkrN05DcEtM?=
 =?utf-8?B?akUwVmtnYW5xVDM1eExzUnIwWkdjQzR4MjliNEFYaGZCNGEvZ3oxUnlUT0lK?=
 =?utf-8?B?U1loVjhlb3JHYnV3ZGh6QUpMNFIvNWZnanZUODNBY21SYmdrMnFKMVVIZEhX?=
 =?utf-8?B?cWI2dzZFcXFrZ0dPWlZEL3o5YS90MjFFNUF1OGhPbWUrR3Z6NnI4V2h0aHd3?=
 =?utf-8?B?VUx3Mi9MN0ZiWnBoNkRtOUlRZXZFUlhZbDRRTjZvM2NWMzJDTHR2R3A1UTNS?=
 =?utf-8?B?c0k3b0R6YVJTcG1RL25Vbk1aVzg4WTlaak5FSDFGZURWY3BkM1phZHN1MDJm?=
 =?utf-8?B?S1BUcnBJK3BibDE3YlpabmFuRUE1WWRFRCtuNnhTOVAzM0h3TTZCRGQvNG01?=
 =?utf-8?B?djNRclQrTmtOVzIrbXJBaXE3dUdyZVNXbzUwOElNU29tTUc5L0Q5ZFdJS04w?=
 =?utf-8?B?bU5Cdk9GTjJtY3VScUlEdlA2VDZMdFlwZEdrSmVaTEhuOFZLT290VHlxeCtW?=
 =?utf-8?B?d3c3QVgrUGFoMzNPYld6MkdHdzhxUDR3WS9Dd29OUXRmdVlkMU9DMWtrZjc2?=
 =?utf-8?B?bU9ueE5FSWFGZ0tEcjVQOWZ6dmtMTXhKRExBM3Q4QVdFb1Znb05NZnltOFI3?=
 =?utf-8?Q?0NP2GD1B8i0dFuENpuKkT4105zck7pllIEVjrpN?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR08MB2882
Original-Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT006.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: d91b85fb-4b49-43ad-e268-08d8cf3f7e80
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eAl68PN2nqE2PbLAnMozCLs+QfrXvHvIWm4cnzPt/URsP9jvnQtmDj4PXJ+reul2NCWSCO5RaiCnD/IDfku1JC7oVf8fdQiD22jaBbRXSFTOWWF0AiJsbglD7L8+Z0DHvYbAUJTumM7a0Y2S6MADagbIWWKuU4+AxotZcg05A7zfMtO7cPezHUr6ZbganTYAZlNKIHgyxH5WViduEOnZSnK5jlYxns4WyzssriilQlM4qgZ5X1vYjD2DKuPzrhBrd/NMlcD/qw9Snq0Bd4HFJUN+2BtsvMfz0MxxjYIRg0ImLjaXowJN7aJWmkydSXgQ5M9T3LTT4u+7yfZvhWQs+EHD1jWw2JC9i9YeHHHzgeIpztoKRQ7EIEwjJrrgkRE9YAtGbh7Ryr6cB+mht+N53mKYwK5Hjtr4napJHVuthxuFG4zRnkGC+EwpCjkTAc9VIapHTw0GXNa6XPm4+cgMnN1Pktk6V8SkhxTGw9MewAeDrgTeR+ii/Bx5Qy2CAxKvfCTQpzqyNEPeTrF5vd0+JpPHho+XPCS0+B6ReJ1e8p1IIpCRfQB3Wpt57BeOOdpZeGtXin+fkHBmxhPOIQQino24o3nsKuz3Yha/964a0D8za6gg7GNaWt/PUqA1CfXIiUbnaHGluMh2VBcaMToc3k5+G+LuDRd2A9bj5K0yX9wSAKe3Eoel10uXnHgiypzp
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(396003)(346002)(46966006)(36840700001)(81166007)(86362001)(110136005)(82740400003)(5660300002)(36756003)(70586007)(54906003)(70206006)(16576012)(8936002)(26005)(336012)(316002)(31696002)(4326008)(8676002)(478600001)(47076005)(956004)(6666004)(83380400001)(82310400003)(16526019)(31686004)(6486002)(107886003)(186003)(53546011)(36860700001)(356005)(2616005)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 10:18:16.7889
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f614fec8-b042-4e0a-771b-08d8cf3f8377
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT006.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB4063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,


On 2/12/21 3:27 PM, Auger Eric wrote:
> Hi Vivek, Yi,
>
> On 2/12/21 8:14 AM, Vivek Gautam wrote:
>> Hi Yi,
>>
>>
>> On Sat, Jan 23, 2021 at 2:29 PM Liu, Yi L <yi.l.liu@intel.com> wrote:
>>>
>>> Hi Eric,
>>>
>>>> From: Auger Eric <eric.auger@redhat.com>
>>>> Sent: Tuesday, January 19, 2021 6:03 PM
>>>>
>>>> Hi Yi, Vivek,
>>>>
>>> [...]
>>>>> I see. I think there needs a change in the code there. Should also ex=
pect
>>>>> a nesting_info returned instead of an int anymore. @Eric, how about y=
our
>>>>> opinion?
>>>>>
>>>>>      domain =3D iommu_get_domain_for_dev(&vdev->pdev->dev);
>>>>>      ret =3D iommu_domain_get_attr(domain, DOMAIN_ATTR_NESTING,
>>>> &info);
>>>>>      if (ret || !(info.features & IOMMU_NESTING_FEAT_PAGE_RESP)) {
>>>>>              /*
>>>>>               * No need go futher as no page request service support.
>>>>>               */
>>>>>              return 0;
>>>>>      }
>>>> Sure I think it is "just" a matter of synchro between the 2 series. Yi=
,
>>>
>>> exactly.
>>>
>>>> do you have plans to respin part of
>>>> [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing to VMs
>>>> or would you allow me to embed this patch in my series.
>>>
>>> My v7 hasn=E2=80=99t touch the prq change yet. So I think it's better f=
or you to
>>> embed it to  your series. ^_^>>
>>
>> Can you please let me know if you have an updated series of these
>> patches? It will help me to work with virtio-iommu/arm side changes.
>
> As per the previous discussion, I plan to take those 2 patches in my
> SMMUv3 nested stage series:
>
> [PATCH v7 01/16] iommu: Report domain nesting info
> [PATCH v7 02/16] iommu/smmu: Report empty domain nesting info
>
> we need to upgrade both since we do not want to report an empty nesting
> info anymore, for arm.

Absolutely. Let me send the couple of patches that I have been using,
that add arm configuration.

Best regards
Vivek

>
> Thanks
>
> Eric
>>
>> Thanks & regards
>> Vivek
>>
>
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
