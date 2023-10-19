Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCAF87CF85D
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 14:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345486AbjJSMIS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 08:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235396AbjJSMHR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 08:07:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9FABE
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 05:05:20 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39J7OPj2017259;
        Thu, 19 Oct 2023 12:04:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=xLWvNdyhUszMNxjWUVNa8LPjorrq9KlGoUFyPND/bcs=;
 b=2UHSLQ76EpN5uTAVYs+uHDX9g4xwTxKWN71q2lvyo1gpYucKRarAlv6sz0khaH9ZVG2n
 NjBd/LGwC++ZdehCsy32NfNG0U6nxjKEqEK8SJcGwAItpN6ziYzCyiK7hVQApQwKXFrI
 OJoFiSCjPbO2jkqGljznmlb4eX7PCBAT9zqqV6h3vjSeaJjY/jUgd9ygZn3lQ82Qt+zT
 QxBLPTogBOpcqGH0zcWIOSW4hyPmFvkS2cjM3XCEk0ApqofvkkleaxPILDxYtoBp4kCv
 n0iA/tqrLrx1XwCADI1A32XQo7MJwK3bgjuCFrHVlQXWA6XaP+F8pINV7Mcq1MbUN5Wu Ng== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk3jthqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Oct 2023 12:04:51 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39JALmOa027214;
        Thu, 19 Oct 2023 12:04:51 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trg56ntpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Oct 2023 12:04:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B3ymwFoAk0LfzMKzYnxbEVXxfumwF7voP2tkCHCegHh9DIQCJcPTSYqiepvimEdsoQ+jfgFBuOpIHgEZqEU0i9cwCryUeAJNjgaWyjw/cjr1f39xEqQGGcE/OW4vUsFyNouOC0T1oY528q3uiszJvj3YClUnXO6rpt7syaW3LbBAjetzxWXLbdg14MYvJMuG3ktuULBS1DGhd4Alg5Fk+TNsuqPvhd/AE4VazWgQOW7KfbzW6k2Z0T8lI5dkkvMrHQtiFVHP5CFFT5d1SOHlmX3DeKqZkMjU298SMngGxzNRqNzfbxPxIyFzYMwIDTsU9+ib3UbvZUCNbSwA+jsdmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xLWvNdyhUszMNxjWUVNa8LPjorrq9KlGoUFyPND/bcs=;
 b=VxDDT+sdn1p0YUft78PCZV12Y6FzbCOw41KAK3ukBApZwyXz057X5Pw4v+DaCLq68htUrUKoc635WPGvYMbyYTtrUpSFg//KUlBEupS/0EpOGOC41MYOelKI7m0Y5WKvXBpiT1Aq26GYzyjjCHYbFyAV/qoXu1f1FdnBwb1xeIKaFkl19QKBNrkzNqd8EZCzzDU1hYxwywZ1wYFzs9nW8jljxOOdB1RdZlqN+lkPXBXRbHZ/nDHCwmUhEA3C1jAE2yCJHj6f9WReU2dukL9lPsFm6QDMw0SQ4re74u/rm8N7tz4nHNMC292bZYU2Ak1N6ij3TTxbbeU6LOQmnJCswA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xLWvNdyhUszMNxjWUVNa8LPjorrq9KlGoUFyPND/bcs=;
 b=gxaI3eGNmQEs5DYOg8QPrq9xZ5j7di3rAe6ctPSDoKFVARVBX8MQNhq131ePgQNJzzOyRKbacc2F2etqEIkVXSlkNbDs4jXC6C2Bsnw2grY8NtNUfCPMfNhy9iqsDaO6PA3NyS4Rr7zH+Ex6m5jumxwlAUM+1zM3n1/Gg9/dTF4=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BL3PR10MB6089.namprd10.prod.outlook.com (2603:10b6:208:3b5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.24; Thu, 19 Oct
 2023 12:04:49 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6907.025; Thu, 19 Oct 2023
 12:04:49 +0000
Message-ID: <18db6263-4974-4612-be0e-811b7795d0b2@oracle.com>
Date:   Thu, 19 Oct 2023 13:04:42 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/18] iommufd: Add IOMMU_HWPT_GET_DIRTY_IOVA
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
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
 <20231018202715.69734-8-joao.m.martins@oracle.com>
 <20231018223915.GL3952@nvidia.com>
 <47f6f1bd-bc06-4efc-a5a7-f76c6b58b61f@oracle.com>
 <20231019120152.GR3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231019120152.GR3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0586.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:295::7) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|BL3PR10MB6089:EE_
X-MS-Office365-Filtering-Correlation-Id: 78423609-72c8-4783-2178-08dbd09b97d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tZ5pw/FtTA50qPphIrNriv91I10jSLxRiIUkJKrOdFuof+7Fb44jVnEnKmdtRt+w5CMftS/RgvboVHLg01ViXS3ni7e36ZdJqJoFjMeMZSm3JrlgC+4LB1wUwHjL3HhSzBik4SU+dzFAl60XNrZVphQfbcYlArcfhVFjwi7g6YAJNqhPAq5KkBQrXUaqY0Bd4bGL0gPNNZg2yuWRLE5WJfRLAT9XVTpI73hkkqupgYsw9Ss4N8nQ4tOIutyubiXaotVXjxBgOEnxcmydebPuGNLTtwUNUCf5OO5NT6JcGjO32EO2OWdnFga2igsdgAmOeUJhxxQSomQvCdYsQI2oqkQLxzDwtGzLT/H6AbnFmK+nJ2cViuSJt11ugtT2USR59SrjWeA16bGgSpsX3VA4FVGqskkeXm9FFjEBptnbrKh3BaXrtWpbUJ6ZowMEI6opE/YclM8BG/6EGF99tF8jhhi2EjsZvLadvbV45+cHFfNDxfAZobD3qgPBCEv044XI8hGU1h2oxCRI+dmYS0HKQ+TN5AvOJODRUNKUZbRWfi9FoOEX8kAOQ8vFcnyp83BTkIfTqw6rGPhLPk21PaVaYhteMUvH1fShP4a39W16yp5c4mfy9zjE2+VSUBaF2GBVDUKVLo3sLq7zsorV8TV1NlesPkF+4sABm+jwI7JGDgo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(396003)(136003)(376002)(366004)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(41300700001)(38100700002)(6512007)(2616005)(36756003)(31696002)(2906002)(6916009)(86362001)(478600001)(7416002)(8676002)(8936002)(66946007)(66556008)(54906003)(5660300002)(66476007)(316002)(4326008)(6506007)(53546011)(6666004)(6486002)(26005)(31686004)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aWUyS1ExRTNtZGl6Wk5RRGs5TDd4Sm9lMXJBamc2RkNBTWhVbC90MVJCWGk2?=
 =?utf-8?B?bFZpaWJaUkZiRjFqb0cvSEpEaDI1QVhZR2k2RDduQUJpS2V5cy91d0xycEpY?=
 =?utf-8?B?dENncFo4Q1owblViR1daQ1l0ZWthTjNLWFZzaVBqSEN0eFNSZHVWakgyQ0Jp?=
 =?utf-8?B?VjY5dXRQM09iSE14RkY4VDF0dVBmdDREVFcwMi9LNmxIQk1paGFKQWtwc3pk?=
 =?utf-8?B?S3BPNHVTemxkQnVmd3NLOHNsWFhzY3BLVkRhMXh0SmZjWjROd0tQanFRTEZk?=
 =?utf-8?B?aEUvTGsybGhFZC90cEFJNlRBU1ZGbU1sRjMvRS91OVBsZGNtSDQwaVBzNHU3?=
 =?utf-8?B?WE0ya2hRemUvLzZMUkdNSVd4WWJIb29zVVZoMnBxQjE3VVpmb0RxQUpTUFBE?=
 =?utf-8?B?YTlncUVpWVh6MWJtSHFQWlkvZUM5L3B2Z3ZUUWRnN0dIQlZyY25FU2JuOWs0?=
 =?utf-8?B?U3dQTDVQWTJlbnJzaEVOWHNVVVRFRHBRaVhnQ2N4ZU9mazc0T21JUTd0S1dj?=
 =?utf-8?B?TUVENlZSaWxSOWl4aSsyR2dEY1VmVnVwWHliekg4Z2xEejcyeFZLVVlSQnBV?=
 =?utf-8?B?MXFHUS9aVm8rUHh2QUJkc1V1Q0t4M1kySDFydzBWYTlBUjNhL01ERWtyQ2dX?=
 =?utf-8?B?OW5HbndvZlFSZWkyUW03ODA2Mkxjd3N2MHJCQkhGNkdkREg0aThyZEJ2RmpY?=
 =?utf-8?B?RVU4aTk1eDNDVzkrTGh4S3FJa29VTjJLSThVWDRhMG5ZZk1uaDZxVEVpSytU?=
 =?utf-8?B?dngyczlKRTcyS2lBSUZxRnNLaE9WNDQxVXNGTXhtQXdUVjNoRHhVNnJNM051?=
 =?utf-8?B?QWZwZzhtYlRBbVMrRk1JazRMdWhUZnZyZGdkY2x6c1YvaURvRHFGbFprVHVK?=
 =?utf-8?B?ZVNRZSthMStsYU1PdTd3b05TRUt5UHhYOWpiQlBZR0s3VmxvVnE5WlZFeDNa?=
 =?utf-8?B?cjVDRC8raENvbUpjQXlQNjRTMzhFRFZXSjArNDhPQmtMdTRlRFB1Y3E5bkp3?=
 =?utf-8?B?a2hjOE5GM3VLWU9Rc2ZxQktwemY1MGl4UGRibGZiZ0YzaDNFS3QyQ2xybU9N?=
 =?utf-8?B?dVp0ZHdrQ1VLemNYMGcvOCtWZGtvOVJnRXZmUGkvajN2ZnVpVFVrbUVLR2dZ?=
 =?utf-8?B?cFRrMlJjeHFVZnIyVWNZdkE1S2x5R3Z0VlNGdkJkbmJmTFJubUpLc1JxeUlo?=
 =?utf-8?B?QktGZk9GV0tyQnp1UUdWZk1QbGR5NEUvemdob20rZURZMS9KcFVBTm9Rc3hj?=
 =?utf-8?B?VXQvaWplN0dTSVRtMEZJL2JHeTJaNnZpeXpDNWg1WnhlT2FRWU1Ja0hOS3g4?=
 =?utf-8?B?TmtNcmVGdi9kRkMzaFMxeDdZNVRuK1RlWDVvRmxuYjNFNXFrcVhkTm9TaUV2?=
 =?utf-8?B?RWl6Q2pLN0JWdHBudEF2b1lKM0YxamIvc1NZcjZ0L2QrcnlnQ0g0dUJaYU1L?=
 =?utf-8?B?Q2tsYmFaOFQvMUNJQ0FLbGkxZElnazNxMFRFb2thcXhnKzQ0c0VPajcrTkdv?=
 =?utf-8?B?aTdzMUVSK01WLzMvVC84R1RtbUROcFJzMWJENC9nM2NrSWRsc09DMzJwYU5w?=
 =?utf-8?B?MFE5MkxjK3pybDVKSUJyYTU4c0tBWlhDbUo4MThGNlptZlFNdFltRDhDaEpH?=
 =?utf-8?B?dlZBNWJXbHRUTTByYUE5QjhCWGgvem4wZGc4SVYweVY1UFpjRjFTS2syZEN3?=
 =?utf-8?B?Sng0cXRXTGFidlY5OU1yVjM5SGh5VmJubTNvZXYvQmpYcjJwcytGbk9yNnhZ?=
 =?utf-8?B?UFRVU2RMZk93R2NELzlDUXNmaCtBdWRyVkhQbEhqZjFxdmdSQ0pncDJ2eEg1?=
 =?utf-8?B?WHRTSlFUMEV6WGVGQ3AxNWJVZ3hiUHNObjQwdXpXcjBZcUtUeThnMXgzaFFZ?=
 =?utf-8?B?TGVrcVRMeTJLNXpVVVZQc1YyVk5rbXIzL1dhNGlFdVExZktmRmxKeUhaOW5W?=
 =?utf-8?B?bHkybkhvYTdvMmJzT1BNdVUwOTlCM3FvWVVmOXg3Z3NUU2hOMlhKYlptZEVl?=
 =?utf-8?B?TG1xaDFiNysyMVcyaU4rQzlRRGFLdlp0amFOdDBuOTAvNTVzd3UzcHVGMmpu?=
 =?utf-8?B?ZkI1andaOGFNUEJpeEZZMGRCNnl3RysrVUltWHNZa3JGZTByUU1WbmRjcEpp?=
 =?utf-8?B?ODZocW1PUXhENkJCZXl2bGw3RUo1NzdweERoNG93V2ZaQitIMlg0OTFuZnpl?=
 =?utf-8?B?c2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?U0FHc1VtNG5aQkp4eTcrMzNJcnAzZ3NnVnhFcHEvMDdTZEtJZHRadUYvMWFI?=
 =?utf-8?B?dC9TVWdER3pwRFVVUEhER0hIdE1VdXUrSWlhTk1XWWYvcFBlL1JFREd5K3lK?=
 =?utf-8?B?dkRKWk9CNERIcG5LSGZTWTEvUU5yL0NzVlZ3QmdBTWcycExhMnBwU1Z3ei9v?=
 =?utf-8?B?VkxFUjc1dlI4cmhXeEoyNjhzb1hDWXFBZVpIOXJ0MGVLNmp0eWZoUi9XVXJj?=
 =?utf-8?B?ZjJoVjFUcUc1QUxmcmZJY2NzdnlzcWl1N1pTUmg2Zy9KZG9QQko3UUt3QWVL?=
 =?utf-8?B?NXdYM05zWm8vSS9Ca0tMajRFemVsMTVnbTRWQ0tCZUJjQ29md2p3cXAzNjBt?=
 =?utf-8?B?akF1eXc5S2NrbVQ4RWJ0WkNsUjlic29NUkFsaW0za0RydUwvQXZYTk1ZYUdi?=
 =?utf-8?B?NE9DT0JSMFdGeHFTOFZmTGZNM1ZXMEJBLys0UUc2cm0xaUpob0x5bXN3YVpW?=
 =?utf-8?B?TGN2SkdXZi8zQUxTTkp0TVlTR3ZhVVdjSzUyOE1QOTJtK3NCL2V0bFBuTlJr?=
 =?utf-8?B?ekNlR0c4OGJLL1lUbngzeE9QVTYwNEFzZmtZZzFuUzNyQ3NFbFBJTUJrRnZm?=
 =?utf-8?B?MFUrN1V3bDRZOHEyakxnRjZkTnlzcnE2TkdsRkVpSXNiSTBuNnBqYkdwdWxn?=
 =?utf-8?B?QkhIWFNTZVJ1eGFGbGdCa05PQnlZY2F0dERSUkt4UTYxR0RhckxacFJMc1Bl?=
 =?utf-8?B?L2tOdXV1Zy9SSWZrQURPeGZ0ZnNMZldEd2Q4bU1Qc1VBckZLaVRMcEJGQk1j?=
 =?utf-8?B?WEJnRkhvUDc3dG8reXM4RnpXU1AwZTNOMjV0WFlCb1lJdU5DLytaOTNCSm9E?=
 =?utf-8?B?R1VZZFhKOHRsUTY1WWMwTHFPMmVtbTZjOVlzdEpTS0xHOWR1N3hXd1RCWEtY?=
 =?utf-8?B?NEtqUlZUem5kRGFUU0VqZjBETUpHTmxCY041U1ZqYnlJbTJYb09mTEJ4TlUr?=
 =?utf-8?B?Y2N6Q3dPM2lTam1wZS80bUh5VzB5RjdyWi9oVlo4NHRwaHBvenAvZVc0RlBo?=
 =?utf-8?B?TVlWMnlPNldzUFFjZ21mcVdGQy9SeXVHenphOFQrNXlvMnJZalBHSDQxY0F4?=
 =?utf-8?B?YW5VVVhNNVdlUWNWT0dHMkRFN1VMejNMRHNvTGV5ajJRT0NKczdpdXVIeWJi?=
 =?utf-8?B?ekI1Q1FaQTBxWUlGaGdpVXh3VWpBU3VuaFZweS8vVlZudzVuM2FvN0NFaE04?=
 =?utf-8?B?a1VqWkRFWUR2eHlMd1ppRnRnaUl5eHZmS0NoTnpmQnA3ZnZkNXlaYkYwVDRs?=
 =?utf-8?B?dXVxU3g1ZkNwRTZwWjYvYm9WQmkrREhNU1lDTkVnaCtjSnVLZ0kxZnR1K0V4?=
 =?utf-8?B?V0N0Z2dTQzBGV0Y3d1JHeVY3Z0Y0RWFRR01ZcG1ucGJLQmw4RFdMVGhhNWI1?=
 =?utf-8?B?SW5UTFl4Y0lFYlIxU1VDK2s5bzNsK2kxY0JZY3hQSElKd2RPZ2pNclBTYnVY?=
 =?utf-8?Q?2fNvZPVW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78423609-72c8-4783-2178-08dbd09b97d4
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2023 12:04:49.0645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O4tkOHCNQlNmKs1MTS16OiqzYxIBs3q591QGiU8Gdy9lAocvr+83HenOfCt+zv6kMZPqesarwe/ETgkSH2JWnCJDTTAOAb2ouJub4/hGYVo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6089
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-19_10,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=886 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310190103
X-Proofpoint-GUID: 6bznzH5UkDXTsF32srsZWB5XCYjPgAoH
X-Proofpoint-ORIG-GUID: 6bznzH5UkDXTsF32srsZWB5XCYjPgAoH
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/10/2023 13:01, Jason Gunthorpe wrote:
> On Thu, Oct 19, 2023 at 12:43:19AM +0100, Joao Martins wrote:
>> On 18/10/2023 23:39, Jason Gunthorpe wrote:
>>> On Wed, Oct 18, 2023 at 09:27:04PM +0100, Joao Martins wrote:
>>>
>>>> +int iommufd_check_iova_range(struct iommufd_ioas *ioas,
>>>> +			     struct iommu_hwpt_get_dirty_iova *bitmap)
>>>> +{
>>>> +	unsigned long pgshift, npages;
>>>> +	size_t iommu_pgsize;
>>>> +	int rc = -EINVAL;
>>>> +
>>>> +	pgshift = __ffs(bitmap->page_size);
>>>> +	npages = bitmap->length >> pgshift;
>>>
>>> npages = bitmap->length / bitmap->page_size;
>>>
>>> ? (if page_size is a bitmask it is badly named)
>>>
>>
>> It was a way to avoid the divide by zero, but
>> I can switch to the above, and check for bitmap->page_size
>> being non-zero. should be less obscure
> 
> Why would we ge so far along with a 0 page size? Reject that when
> bitmap is created??
> 
Yeah, right now I have an extra

	if (!bitmap->page_size)
		return rc;

	npages = bitmap->length / bitmap->page_size;

It is non-sensical to consider the whole thing valid is page size is 0.
