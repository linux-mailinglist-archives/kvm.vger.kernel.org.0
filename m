Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396826E0B6B
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 12:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbjDMKbA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 06:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjDMKa6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 06:30:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC952729
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 03:30:56 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33D6XuvB017280;
        Thu, 13 Apr 2023 10:30:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=9xSTBwFIGPQqELPEgRaDo33bVJLMI3D7zhwuDXDsUa0=;
 b=ia8/UNnvANtVPKAO+BzUWeQsIUPOIFDLTJzohoBldZ0t9Pzlk7BRo8YuHI/ndE14kD/7
 ZLQAeI49+YFzzpql9w6emoHSrOz9MOHiadwScY3GDouDvSGpjlqCUBmQ2aUObJnANdOK
 d6LCkFUrlwVsD+FPL8xdPQkzYqYnVBgFWICURGKk9C+CIYuUNdTovfzZUZPqrslU3eM1
 4rmDZrymm/sEYKX/t8+c+HdXFEvldSOrlDG8LI5qaxrY2APwVvHkksZT2QnPSIpeqH6O
 0pDKtdhMRPSwAk4sUF4IImALUktp5zqk87BLDKYxUuXitgPaFJkcBNlHAq8P0EAHkViy pQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0tttmm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Apr 2023 10:30:31 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33DAPQMu017476;
        Thu, 13 Apr 2023 10:30:30 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puw8a8rmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Apr 2023 10:30:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xk9Q/Waw5wWaB7NrTqx7hMH1P1sCvVpW/u9LRxJIYbpvq5QdQBzN2KQmtKSzaIvTr+dfnlyPjiPT7JSSD0lcFL0hFeb3VVpN4B8XUEyouI62DbFrZRautAn4sTGtjjy44Hj8cF/bCNdVHZHT6QnJI7Q6NB8GrLQ0JiU6CH/9a2oRDR1QkpHRZEQZUu9SZhdniKZAb4ipPj6OEGXR4hX+RezqVF2s5bOgllqBsIVpkPKgB7wrkjR8Hcv5noy0i9XfH+n/F868nUk8jbZISnZN3K71zlx5IvnWi8/4UG7s6gocUR2OMgktbINeRMASf8KjCs+4SP7Qt4gJiXf1enhjQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9xSTBwFIGPQqELPEgRaDo33bVJLMI3D7zhwuDXDsUa0=;
 b=P+XcsnJ6PdU8K7xsa7N76x4pbZwHleZHx9jKbTUE3Bhv+siPPqK2YFKocaXLC6OoLkaazOpioMe/Zll7LWflQfkZcka/Ww5DmGTA8aOp5+BKplaUbGKcEyEjQJzZNicPnIRlUpdG8lN5Pu1WjfA/GY/7XqZOgxnFNZ8+UfiFMi6arY0uOUTG59m6CubT0CtZi0k2/vAVNi9WzpHGj5cKWS71xNkLWAds+wU+cNEJXn5vFwlEI2r/A85YsWO4PuYozviH7V/a+kJGc6buoyPvGLufWXKPEn0xR9XDG/JUAtBOpLjMCOPW7T11jyPPHDeIlOgEwRps7d1z5CmgQuK46g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9xSTBwFIGPQqELPEgRaDo33bVJLMI3D7zhwuDXDsUa0=;
 b=TgFCWMnDtFM8DvjfahaEQKaRuJgdgD6cUe6d9BVnuKnoiVdSg8rXEO3LbanjuALUWSZ1DwhBYoJ+LfKTDu+bImQNgBkQ+s/cKYXQpu8BTK5gWA7Axuzg0p4d71QTDSUL9qarwACCEJkQwRExyVzNlKo3a2TAKU7lKWykprjob0M=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SJ0PR10MB5890.namprd10.prod.outlook.com (2603:10b6:a03:3ef::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 10:30:25 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b%3]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 10:30:25 +0000
Message-ID: <0677881c-f801-075c-7af5-efa7471c6e4e@oracle.com>
Date:   Thu, 13 Apr 2023 11:30:19 +0100
Subject: Re: [PATCH v2 2/2] iommu/amd: Handle GALog overflows
Content-Language: en-US
To:     "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Vasant Hegde <vasant.hegde@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        kvm@vger.kernel.org, iommu@lists.linux.dev
References: <20230316200219.42673-1-joao.m.martins@oracle.com>
 <20230316200219.42673-3-joao.m.martins@oracle.com>
 <b5d1b9c3-7c7b-861f-a538-f87485e60916@amd.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <b5d1b9c3-7c7b-861f-a538-f87485e60916@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0151.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::19) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|SJ0PR10MB5890:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d8feec1-c91d-4e08-d41d-08db3c0a17f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: igd0DK+EiZeA3xlHqtxh7rdMoXheS246gpf7czy//x//iFvC7KQsVHQqAVqAi9ICIQIZzBwI08ojl2mdcF3dSABzUSk5plVLitk+4QR4IAaeWge+zvFQfxbhPwpLD/kaoms3XmBzqNPNH70wsVY9WFx9i6jFY1xYpg1T0nrk4TmmyaU56eXtLsK0PYp8Go/BnEJmcnszb51MRCHVv9xoWgiIkMTZQmSIksYdfMhS2E0SdYjv4GKlMNC0dNyBbUiWVebys2+TcFbbX+sYTzPC88nU+x10Wh8lAuXvMIY+x4C9uyUU2EMZc/YqwmPxMnirTptVuOag5wZAr08q6AuoQYvwH9ZAGcWeK6BP2DRAncwyRAjogqEHtFbb2+9gSFpsPqd6eCR+mOnZvaCE0geJB0ukt/fbvoDtKdth0NattxkYXIgLY2V4mzm2LMl7K116UwTh8x4on93y7fb2i1L0kQKpi151k/FKCqQbRkv3rZ+xBsKw5O5k0Wcs0EAyFX+1pYwzeE0PWLmDtFbk/Etlpkh8QqVnc+BhJxiD5k/B1mHzarI4opuz1CqFAyo7FXz/ghXiVfkGnuxuDrGahw+mPfu5R52tnlUwSiGIb43Z6ICnZES+wU7I0j4ZmE+CS3f2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(346002)(376002)(39860400002)(366004)(451199021)(6666004)(6486002)(6916009)(66476007)(66556008)(66946007)(4326008)(36756003)(2906002)(31696002)(86362001)(41300700001)(5660300002)(8676002)(8936002)(316002)(38100700002)(478600001)(54906003)(53546011)(6512007)(6506007)(26005)(31686004)(2616005)(186003)(83380400001)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V2IxbWU2eDdab3hFOHpuVFlrbFk2OFNEUUFxTGk5ZnVINUZHYmNRbkJ5eDN2?=
 =?utf-8?B?eGVaUXMzSyttS0lGUmIrQjBKM2thNy9mRmw4M3lxS2tWZDZYSld3Y0E2Skd0?=
 =?utf-8?B?MytrT0M0SFZ4c3cwV2tmUng4NlNvTGVOaHE4TTZueWdMNHBaczIrTUFFZGtK?=
 =?utf-8?B?VHYzcVUwZGc4NE9NaFNkZVhUMEhsYUx4bW5EWmdxQ0c4dXJuMlUyWU4wdlph?=
 =?utf-8?B?ZStWby9TeGVENmpZanJsbk1kbEJaZGkvYVJFc1VKdDFJdVpTM3J2U0ZQUFBx?=
 =?utf-8?B?UU43SllGM0U3QUc4YWY4T0syVlAxSW5naTc5QnZPTGtNcDFWV2lwZ2dVdFZa?=
 =?utf-8?B?S2xCUFFQWE1NSXBjTzkzcXpmdm13dzgrOUdveGNTZ2dLakZpOG5kN21GbEFJ?=
 =?utf-8?B?WklKamE0a0pZanBlOU5GNXNPQUF6V2d6TnVCMGIydDJ3N3ZRcnRRc2M1QnVI?=
 =?utf-8?B?ay82RW5EdjZMM293bEpwK21CVnlJbVhMdC9xSnl1ei9IejIvaDBoVzdDc0Q5?=
 =?utf-8?B?QURTK01VQkhhUUFJa2FXODk4b1dWaW5KT1JLRjdWNlR3Vkd4dHZBQnp1c2FC?=
 =?utf-8?B?L0ZXU2hQWk52UWJIbUsxR3p2UEs4eTJLMkhkSzd1bXcvUGQ0UTJpQkExTGdj?=
 =?utf-8?B?bWU4d0thSk1rQXdSQkVIcjIzeXZ6ZWN1N1pCeEt6YUdoTS9qOWxWZzZkVnJr?=
 =?utf-8?B?djc4R0o1UVN2VldOaUVPQ29Ld252eEMxRlBpUEZGRE55aTlIWXo3Y3o2VEhw?=
 =?utf-8?B?ZDVwT2s5cEdBNXczbkNXb2NmSEtBcFFMWFVKRGVhcVBxcDhiMXVmNEY1K2N4?=
 =?utf-8?B?S0xMaDFrZG9wUzFFempqaGw4a2c2MnRwQXJ4L2NtamVlcENrWk5rS28xT3Zq?=
 =?utf-8?B?VmQ2Z3V3RWtVeDJ5VVNFWGZ5NklaeVU5K0R4cFg4MGZpVFBEdUFOZzlCWEJE?=
 =?utf-8?B?QWw2S3VQRmd4aUZkb1FwNTNKcVN0TWVnWW5CdWpBK1hEaUgvRC9wNnA4UW1B?=
 =?utf-8?B?cTUvd2NUMGVPL3JlVDhzbkhPNk54V3luV2FQKzh6SU9jMzkxWFB3dmQrY0Zy?=
 =?utf-8?B?Vk1pZnQ3bWZTMk1ad2dIOGphY3FDM05Ob05pZzdoN3ZhcmdPaGV6cm5iVmxF?=
 =?utf-8?B?RUdZbmVVQ0tEWjhZUGFBQ0N2YmFTcWZjdUNtQVloNk04VEwvL1ZtR0FSNnhi?=
 =?utf-8?B?TS9KS1ZUWnRRSTg4N3RaeGZjaTEzOVdLbXVONkNRblowczVVYVVlTzlyUXdu?=
 =?utf-8?B?WWhPaG56Wm95SE5ERElXSndobDRvR1JRMDdkME92TzVScXpSSVdhRjZBSEFV?=
 =?utf-8?B?eXQxaVhoZGpwZEh0Um41cGVUVjJkZ3h0bXJaRHZac3pOblRsZWdDL0hGamFF?=
 =?utf-8?B?ZDNTQWFFM0doK3NkOTdESUtqZUJDRDhpOU1ZQUQrd0hVQmZvUHJwbm8weXhX?=
 =?utf-8?B?anVYcUl4MUZhdUNZRWxqSGRXUUJjMkFiZVpZaWFnc3F3ckxocTRpU2loMHoz?=
 =?utf-8?B?OHpFYTZKaW5sYlAveUd3Z0xEVjNiNFNscFVLS3BrSWtmS0F6ejVrT0QyblFt?=
 =?utf-8?B?TnF0bG1lb3ROdmNBdTB3YnNxQUl2K1grRlpaaVh1ckc2d2RUellRWFluRWtO?=
 =?utf-8?B?d0pEODJud1NsVFV0YzlNdUN0UFRzS1A5elpoUlZtVVMyQnFqMlRsY1BibW0r?=
 =?utf-8?B?cWJqajVYSzF4TE56WTkyQS9RcDB5VGR3TnowYUNnUUlOcTVaTXZZeWxtVUZW?=
 =?utf-8?B?NHpxWGpvcmI0TjNSZ0NDN1h1NFZINFJUeEZBZzNNT0ZPRmRRUE1KbU9iLzdw?=
 =?utf-8?B?M1ZGcHByNlpPTTBJMkZTY1dYclRoZTBQNkFic0xmU3BzeUpSbCtoTk5zTnJs?=
 =?utf-8?B?MjdJbVlSaXJyYk9QVm1ORWJnSDBHdEFLdC8zdEZ3blRSL1NzY2pUY2J4ZUNN?=
 =?utf-8?B?MnVtQW9hMzl6YTlLVXY5RTdVOUN2OUgzNVRETlVWb25NVDFLUzVpSXo2NmZk?=
 =?utf-8?B?elZUL1NOWnBiTW52aGVEYnNrcjhpdXpZVFJSSVBWUzlwcUtzR3plSDlvRkZt?=
 =?utf-8?B?YVBBUm9CWGFQemlSL2lhbDVDa0pmMnlFaUYrYkkxYXVoVTRsM1h0bE03OXhI?=
 =?utf-8?B?MmRtZHNmbCtNaG54N24zeHpQVHRSc3p4K2xBYjFWTFJkMmptWml1N25kUEc0?=
 =?utf-8?B?YXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?TjZ6R2N2N2ovbExoTDFwUjNsRkdtZWY3OGVaY3FlT2RabmU2OXdiRFZBWkdu?=
 =?utf-8?B?NlpTdG0vck5vYnNCbSszTE50T1BqdEtEVnlnTkN6NXF0ZXFJMlFJbWFjNWpU?=
 =?utf-8?B?QjE3bk1GVHhkWTBGOXFIZkZYMFk0WlZUclRlTjlRTzM2R2tYWHpCQVFRWWRY?=
 =?utf-8?B?bitLMFdwSi9NeHM2cDllRSthQTRvZW9obi9sUVRlOU8rMDM1QlhiYTNuekVu?=
 =?utf-8?B?VUtXODVUWVJtNlFoUFhYclFMMFJTTTVZTEN2bkE1ZmsxWGQ5STI0Z0VPcVlI?=
 =?utf-8?B?VDJ5WGJZTE9PeFM1SXBIeU00a0dWNFlLNHg0bUt4MUFabStURWVxcXpHU1Ny?=
 =?utf-8?B?SW1PMUNReVZUZE5BOWdqT0NyTDVBSzdZT1BvN2psS1dBOGN2cFZwTk1IOWRD?=
 =?utf-8?B?clV0aitEenVpNUlaeE4vbnRqOFZ2VXNGR2RYQThBektTZ1RpOUNRWnVsTm1s?=
 =?utf-8?B?ck51Q24yRWtWRjhTVmpWcWdvYWtmTmZjZFNmNnk0Z3BzL3c2dnlUd0puZldt?=
 =?utf-8?B?TXRmelV6b2RscDJVZmZEZDdoYWk5cHNSSExOUXdiY2NXRGVSOHEwaEprMWFw?=
 =?utf-8?B?elM3ZUNpVjdRQTV0TVFUYnFpVzgwWTlKMk9mdjRhK2dGWkZxZjVTSU1UWDk4?=
 =?utf-8?B?NG9wSCtnSUxYSk9HWjh0SlJxdHhTQjVXMHl1a2JuTjh4MXRMamFXMm1CSzJ4?=
 =?utf-8?B?Wk1kaXFuRVQ0ejJ3T09BbmJtQ2s5dmFpWEJJRzBlTmZOWGFpQ2RsanFBbkQz?=
 =?utf-8?B?TDI3cW45cjZWZXpkMCtFMGx0cjVjZHJyU1hDMFdiWDBKaXZlVm53My9uWDJZ?=
 =?utf-8?B?UDMxamYzNHk5OWRmN0Y1UDZNQVR1Q1N1dXhFR0I3K2xUczVpSWdnVUpCMWg0?=
 =?utf-8?B?aitHUGREaFdicDFNV2pudWNsUlU0UFVGQXBYNjNaQlZydFFiUnU5SnNNRU92?=
 =?utf-8?B?SEVCOXpQNkVjcDBGUVZTWFhNTG4zZFdsV2FEbDErclhsSXVoNzFMa2J6Y2pU?=
 =?utf-8?B?UVo1Vy9tTnd5Wkhtb2JZMkMvRFU4Mlg0bzBWUmx1empLeWpFL2crT25kT0tG?=
 =?utf-8?B?ZDRqczI3aExvSi9mYUo5eDlzS1lNc1U3blVNNFJvOTdMNmZ6SGUwVjBOVEtj?=
 =?utf-8?B?TkllUjFBTkh5NGgrVHF4L1ZjRkZEdjJTd0grZHhuSTEyTVdQUTg3L2ZDY1Y1?=
 =?utf-8?B?ek5MRGlTeFpKQVFVNFlreURYUlA4ajNGSnhrbXYweHJ6YTFSWWluWWZVbDlN?=
 =?utf-8?Q?Dq7n5S7VMST74lb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d8feec1-c91d-4e08-d41d-08db3c0a17f2
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 10:30:25.3810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 13HpQ/ECnzO3mpEev26rlSTDFJ3N9H2PtEfCmtgtJBmXLfW/bciOa5hXmYwjOQrK9yGRhs/bwewyU08bXA3TQSyk/NltBCMqOZkSyZVGEek=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5890
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-13_06,2023-04-13_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=639
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304130094
X-Proofpoint-ORIG-GUID: BAK8VThpdMdP6B-WI_NoNQs7rNIBt0E1
X-Proofpoint-GUID: BAK8VThpdMdP6B-WI_NoNQs7rNIBt0E1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/04/2023 11:24, Suthikulpanit, Suravee wrote:
> On 3/17/2023 3:02 AM, Joao Martins wrote:
>> GALog exists to propagate interrupts into all vCPUs in the system when
>> interrupts are marked as non running (e.g. when vCPUs aren't running). A
>> GALog overflow happens when there's in no space in the log to record the
>> GATag of the interrupt. So when the GALOverflow condition happens, the
>> GALog queue is processed and the GALog is restarted, as the IOMMU
>> manual indicates in section "2.7.4 Guest Virtual APIC Log Restart
>> Procedure":
>>
>> | * Wait until MMIO Offset 2020h[GALogRun]=0b so that all request
>> |   entries are completed as circumstances allow. GALogRun must be 0b to
>> |   modify the guest virtual APIC log registers safely.
>> | * Write MMIO Offset 0018h[GALogEn]=0b.
>> | * As necessary, change the following values (e.g., to relocate or
>> | resize the guest virtual APIC event log):
>> |   - the Guest Virtual APIC Log Base Address Register
>> |      [MMIO Offset 00E0h],
>> |   - the Guest Virtual APIC Log Head Pointer Register
>> |      [MMIO Offset 2040h][GALogHead], and
>> |   - the Guest Virtual APIC Log Tail Pointer Register
>> |      [MMIO Offset 2048h][GALogTail].
>> | * Write MMIO Offset 2020h[GALOverflow] = 1b to clear the bit (W1C).
>> | * Write MMIO Offset 0018h[GALogEn] = 1b, and either set
>> |   MMIO Offset 0018h[GAIntEn] to enable the GA log interrupt or clear
>> |   the bit to disable it.
>>
>> Failing to handle the GALog overflow means that none of the VFs (in any
>> guest) will work with IOMMU AVIC forcing the user to power cycle the
>> host. When handling the event it resumes the GALog without resizing
>> much like how it is done in the event handler overflow. The
>> [MMIO Offset 2020h][GALOverflow] bit might be set in status register
>> without the [MMIO Offset 2020h][GAInt] bit, so when deciding to poll
>> for GA events (to clear space in the galog), also check the overflow
>> bit.
>>
>> [suravee: Check for GAOverflow without GAInt, toggle CONTROL_GAINT_EN]
> 
> According to the AMD IOMMU spec,
> 
> * The GAInt is set when the virtual interrupt request is written to the GALog
> and the IOMMU hardware generates an interrupt when GAInt changes from 0 to 1.
> 
> * The GAOverflow bit is set when a new guest virtual APIC event is to be written
> to the GALog and there is no usable entry in the GALog, causing the new event
> information to be discarded. No interrupt is generated when GALOverflow is
> changed from 0b to 1b.
> 
> So, whenever the IOMMU driver detects GALogOverflow, it should also ensure to
> process any existing entries in the GALog.
> 

... And I am doing all that aren't I?

Or do you want me edit the commit message to quote these two bullet points from
the IOMMU manual?

> Please note that we are working on another patch series to isolate the
> interrupts for Event, PPR, and GALog so that each one can be handled separately
> in a similar fashion.
> 
Cool, if possible please CC me on that series.

	Joao
