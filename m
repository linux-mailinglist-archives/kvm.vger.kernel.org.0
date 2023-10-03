Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E267B5EB4
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 03:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239002AbjJCBd3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 21:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbjJCBd2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 21:33:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890FFDD;
        Mon,  2 Oct 2023 18:33:24 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3930ivUv020142;
        Tue, 3 Oct 2023 01:33:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=OT9Zet+5bgxcIl8K6BSDDnfJit5gp+/DK6lxy5dXODE=;
 b=MrEJuekl9X1M5ilpn71IWqmhM/tuOFxxbkRblaq87ekbxrE+VzkeNZvd3ED5zED27Ymz
 8nFOwsFCA0bBfXouheBxNc8P5PhAuGLBIKViF8L6QNy4vrO8XzHc7tPObJdr7t94c5k2
 E3+DAXMM57qClblBYK6gkOA7yQ45klnd/728Zz0TmtxXAKbke779CgdZBsS4Zho+mwJg
 omkMcRJEZZb4ZbmoZA+Io0SGF41TzZl2fKTY+YCscjHGm23zx0YZOH5ZM5QQp619SLX0
 wLwZlH0QK33CjE/+eBRzDaStmO5qjqSjlbWrlwNRsayzV1LgjfKz0d5yaxy8rYg2S1bk eg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tea923q78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Oct 2023 01:33:02 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3931PS4r025921;
        Tue, 3 Oct 2023 01:33:01 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tea4bqd0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Oct 2023 01:33:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UsHvRxv4NEzDeQMTP4Bvwd6KlbGNsH6ElY8qpMFb1o1yL4VWIZkD0vqpVSvcACsmzf0cKYE8znEy3RqRJBfjFnGigJwoiajGWe2SOuPB8TP8tOz7WzkDcraAD9lenytrhB7Q3L4gqkrjF/LrQl+m5X0P+H/oQ6vEbTh/49K2IAMc63yHqH5DuMeCArV3+ZHyuuDXHzn1YeY2N/lyRnZjaOGumYK1KWu69H1mACHxD84mVtJLnvVDkkqD5sRu7HXvXuifsK6sulFRiq/4bnEflFUZJ2OyfWDY4Js/RMtRagmlDJcUBmbdUqXCbgvMvDjMmwrK2O7olLWrAh/RDyce8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OT9Zet+5bgxcIl8K6BSDDnfJit5gp+/DK6lxy5dXODE=;
 b=DeyU0vvCTblFSr2WabUq62XKrKdKUDpFQxdCZwq7XmF364crzDJDxUYq85W/12rlfjpBaS3EBj1YzX6Vg/xrMzbd8OU6+R8hyKHEZp9REVskwKioEEqG8wnr33zrcdHXIXGP0IDEX6P+FoWTwi+YBg9vTSp0+BUDqcqgUmHU8KJT9UuefR7XXRK8+w2L8km78i8mQD3RNom06iHK2B5fiocSr0kQh/jPc/UyWNAn6NV2O85987C+7CgscnHwAu7t1DvJcQbEzwZ2dLJbWSgclmkFSmzyfZaKy4cBwwOyx6JJCN1210peNMCHS86fuJHiNgubG10KxCq55P96TJlKeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OT9Zet+5bgxcIl8K6BSDDnfJit5gp+/DK6lxy5dXODE=;
 b=zWL+6rJra2abHFIQorU1xm2qhz1a07w06j9wF6ZCP77Nj9DmxeCEd9oCxC685zPUyeQGVy9KrFxXoCMFrP9CjWjwqqap6F3e+n4E2iXrFoM1Fibr5Ue0flqyqQbCompl6KWGEaVnTVdzedDwZDnbLA2j1hiWzXlcNS/9GjkcWUk=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by BLAPR10MB5298.namprd10.prod.outlook.com (2603:10b6:208:320::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.33; Tue, 3 Oct
 2023 01:32:57 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::7e3d:f3b3:7964:87c3]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::7e3d:f3b3:7964:87c3%7]) with mapi id 15.20.6838.028; Tue, 3 Oct 2023
 01:32:57 +0000
Message-ID: <afa70110-72dc-cf7d-880f-345a6e8a3995@oracle.com>
Date:   Mon, 2 Oct 2023 18:32:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH RFC 1/1] KVM: x86: add param to update master clock
 periodically
To:     Sean Christopherson <seanjc@google.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc:     Joe Jin <joe.jin@oracle.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
References: <20230926230649.67852-1-dongli.zhang@oracle.com>
 <377d9706-cc10-dfb8-5326-96c83c47338d@oracle.com>
 <36f3dbb1-61d7-e90a-02cf-9f151a1a3d35@oracle.com>
 <ZRWnVDMKNezAzr2m@google.com>
 <a461bf3f-c17e-9c3f-56aa-726225e8391d@oracle.com>
 <884aa233ef46d5209b2d1c92ce992f50a76bd656.camel@infradead.org>
 <ZRrxtagy7vJO5tgU@google.com>
 <52a3cea2084482fc67e35a0bf37453f84dcd6297.camel@infradead.org>
 <ZRtl94_rIif3GRpu@google.com>
Content-Language: en-US
From:   Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <ZRtl94_rIif3GRpu@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR20CA0008.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::21) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|BLAPR10MB5298:EE_
X-MS-Office365-Filtering-Correlation-Id: 989a4059-f7de-4e29-353a-08dbc3b0ac23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1dclMfbbJtIjSJ0EaGokeAu5k8IajPtDDE/26/DEYjImgBSwlvVwSPakYMCEGmQLf5nJ17ryfQRkS8qGjNcYgiW9AtF8+z2brGhVNkCHYUnZcyOWomFQ6FGvaLOu7xVDmStW1iemIafEWfD8YL4z9RL8AlDQTpv3F7InpvaEgmsi4lOs0xFKQc1uSWr0OlvamcgY4pS64PV3BW6y4W7W9WgU91BlSOEpesGQOqqjfjOWe3IVLQlSIYt+smzI1qZXPeugfE/Cg3TSWs9BoR6twp51HjgckkVh9iWy72RjWeHtEGgoulfK4KCpKM0Zobm6y7cK8R5I91lqVOgq4mWHxKOHnhHel9Zl/21CDN+LF8soZPb2ej/8e34b2Tml+MqrEPZowU8YHPjcmK/W/peqlAk1FUsBgVqerj480FDHoAmMxw0e2POblJJ9c3NuyjE37TGMNcx0FcWC4gNIuL4XLWGwbAGM4/ABz1qd7CpVaBWt7ro3vV9pTTOBxwFsW0GamE5x//NWmlcKoDAijWWInWTeHmZdpFY2T2JPdRfiiiOU1SDCbFlmNEzC9k+mY27m34+6pIKr4slgdSvLzvk6+2/8OvgJVbaov2sFbWXK7tGmDMMH3BulMiyagAoa0Qh3Tuk/ZvW+Rsd37zTZPeYz0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(136003)(346002)(376002)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(66899024)(38100700002)(36756003)(31696002)(86362001)(30864003)(2906002)(7416002)(15650500001)(6506007)(53546011)(5660300002)(6486002)(966005)(478600001)(44832011)(26005)(6512007)(2616005)(66946007)(66556008)(66476007)(110136005)(41300700001)(316002)(8676002)(8936002)(31686004)(4326008)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OUJOdk8xdHpGZXFUVURxc3M2OEl0V2cybms0K2xZMkpaelI2MmZxem5Fa3p6?=
 =?utf-8?B?Nzdmd0MyTkpVQkpHb1p5bDRLMkpoRGpvMWR3SExiTVBvUEpjVHhORDNSb01v?=
 =?utf-8?B?VDd6MnZhOTljR0Q3UHNQZjVibGRUZzdxNk9yR21KQTJGKzJETElUVnlER3VR?=
 =?utf-8?B?VXJkTzRvT2ZPc243YmhxS01xSGFTWElGY25WQWk2QXdWME82OGxQTUZTeGZ3?=
 =?utf-8?B?UTNITk5oTjhCdnArNUlrbVAybDl3azMwbW5kWnJqVUJ2ZUpaQ2p6K1dZUnVH?=
 =?utf-8?B?M1M4dXNOMVVhUmJrTHVvMFZwYlh5cEVodG10QXhhTEEvQ3hobEUySEJLbUcv?=
 =?utf-8?B?TlU2eDFRVmQvSkRPUTVyQlFuampIL0NMcHlDUkZiVUp5dDlsZGkyZ1VCVTda?=
 =?utf-8?B?bmcxMVhpdGtGa3J2aEVNLzFVemlwMG44SFJWcnF0UzdXeS9PeXFncGdLMmo5?=
 =?utf-8?B?TTVnV2hVS294Ym5lWFNsdVJ2VTdXeHh2WTJVK3JXMUFTQUJFZ09FMndudDFH?=
 =?utf-8?B?eDNZb1RBVElJdUV3WS9iMWk4ZnRrTmREdThZWUFFd1FHWXZqM01STDcxbGhi?=
 =?utf-8?B?ajhtNUZsdXRwekZ4ZnlIQkh5dnlZa3gvMGEzWlpkMGlBd2dUdkVJMmloRHZ0?=
 =?utf-8?B?Z2M4aXl2dzB6YjYxUGU4UVNsZGtveTZOZTRaaVR2Q2t0VlBGRDk0Q2dJUmhL?=
 =?utf-8?B?cWVBWm9FSVJ4Zjdpc1lUbG5SQXRNdWJHMG92QVdMc0p1QlRJcjhDOWc1cnZI?=
 =?utf-8?B?eHZnWTRCUC9UdS83SGh5VmxwWDc3ckRtTWRCNXNBQWxwMlJ5VmRRdTVkT1Jn?=
 =?utf-8?B?YWsrejVmaHZaMWpJRjgzZ0lET1MrS1dSZ3llZHZJTmZmd0xkRlVNT2owcUJD?=
 =?utf-8?B?amhFTGVONzBtWkU4TDZYQWFJSENoWEFScEdmZlVwYWVIQll1Y3BOM21MZUVr?=
 =?utf-8?B?YUQyNXN4ZFoxTkFHSmQyTmdoQWg0dHFNSjdIVndvTHZ2blJteGF5RnBhdFA1?=
 =?utf-8?B?K3BJOUd1OEoxMUsyZHM4Nlk3bXFWN3VDd0FjVUhqT21DV25COGcxcnQ4WVFC?=
 =?utf-8?B?dXcwLzRvWGp0dysvU3BZMGtXTmtxemI3cWpLQWtGOTlXZEpiQ0xva1hmUCtQ?=
 =?utf-8?B?aUo4OHh3SVV2OUFONEpkT3RHYWU2djA4R3ZSOEJBM3JhWjhpVU1ma3RSZEMw?=
 =?utf-8?B?YXpZd2xiMFFHaUpZbG1MZ2RSamtqa0U3V1VrZ2ZjVlJ6RjJRckRkKzVNWVJh?=
 =?utf-8?B?Q3BYOG4yRUh3REE1Qy9wQWgzU1VFckhWOGVteGpCLzRxNXFFK0M2L25sZEVo?=
 =?utf-8?B?OWZZbWk2eWhiNk9uanpQSC9YV2xDYlRveGNiRytBVmd0NWF2bnNDSENNQWhT?=
 =?utf-8?B?L2EwTWc3R25IMU9paW5NMlJLelpKSmR6Y0t5M2F4aUgwbzRiSnFKd2ZteVl0?=
 =?utf-8?B?T3c1VFlzbjlvQWd5MkVTTGRoMDJLNVhRZUZjUENIQW51OW5kZWJ0bFFqWDZF?=
 =?utf-8?B?UWpxb2oyeFp1UVYza3UwSmNtekxkc283bnp0RzU3eGhxWldJaTNmUERWU0ZJ?=
 =?utf-8?B?UXVaLzRxUElLQmRRVi96VkE5a2JwazZVMlVnMHBjSGcrT2JPYjNjVFU2SGtM?=
 =?utf-8?B?SFY1TkJRZVNkODYrN3VsczN6R29KY0JPTE5weE1GdHdrelVjcGkxNFY1TGpn?=
 =?utf-8?B?MU9FTDVrckd0Uko0ejdBamh3bGtpN0JURGxBTWx2U2ZTUjEyRzA4RlhLbWxu?=
 =?utf-8?B?V0sycE1Cbyt0dnd6bzFSbWFtbjFsdWxrQStOeE84dDZVemk5c1NMckp5OEdU?=
 =?utf-8?B?eWdBQ3VaQ01lS0VkcHNBVG9aN2tJVmxSZ2lEZVNVa2h6ZWlDdmNJOGtzQk1T?=
 =?utf-8?B?bHEwZXFVTUthTEZRS3cyMHl4ZWJmR2Q2WUFMOG5pYk5BSXQ1RXdTdzk1VExh?=
 =?utf-8?B?d0JFOVUwZ1VmWlBKVVFja1Y4amF3RWdvWjBIMDN5WW83dTcrZThlRzFabHhU?=
 =?utf-8?B?cGlQY3c5RlJBOUt4a1RvYlZGdEkwMmhMNzk5WmE2OEdxbjRVZXl5REhqeWZM?=
 =?utf-8?B?eENlRE56bXZnbXIvbDIrZ0o4ejNOemowYXhYVzlvNExmaWRUVDg2NXpBZ0JF?=
 =?utf-8?Q?je9Aq4Yg8Xl/AvMwfpFh09peD?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Q0w3K2pxaHBEUVJCWW80UWFoUTVBR0R1ZFR5UW9nRjlZbVpMcmRwR29oNWpS?=
 =?utf-8?B?cnlWcFVsSFZSQjI1ZkxMSVgwOFN6ZkxqV1ZRSUtmQUkxVzFCOW5zWUdFZndQ?=
 =?utf-8?B?Q0VJWUd5UXhsYXdPVXBVNTZJMTlMT1B4M1lvaHUvOS9uK1FpWng3NmFxT2dN?=
 =?utf-8?B?UlVnY3FsKzJ4bDBIY3ZwWmdNL1ZDWWJNb01NS0YzNW5wU1FBUzVpYU5SaXdX?=
 =?utf-8?B?bU5HQWtTY25hMitVays2ZDFNTlpSQnYwbjc1bTllWWtoR2Z4SndTNHVwWTlY?=
 =?utf-8?B?VTFYMVJ6QUZydDVYOVN3TWtyeGt2REJVbVJCRkxraVZGMFdnL3VXSE5TbFNh?=
 =?utf-8?B?emFFKzVhWlMrTjdiQS9BalpsNXk0R3cvQnhzOWhkSnEyUnNIa2lJcTNuQUR3?=
 =?utf-8?B?RkJiRlEySFlVVWNnOUhXY3NWcC9HbmZycndsTTArTVp5VmpFa0dUbUFvOWpv?=
 =?utf-8?B?d2wyRzlZd0QvNDRvZ05rcE5QYkIvbjFEalJpcXFTckRMRjRXL0RwaUZwUktq?=
 =?utf-8?B?WDROVFc5V2k1clFNSXpLUFIyeHJMWkN0R1BuTEg0QllaaUdHSVlIM3dqUEtz?=
 =?utf-8?B?K2xzZXZVQmNKeFNYZEE5VWZyNFRRVnFnMzlsTjBXUjhQWjJYS3NNdUh5Q2FJ?=
 =?utf-8?B?UUo3NDhDUmRJeFB1bW11cVR6SDZFMFoyRzRtZjBXR25ZK20vYlp2V1JTejBj?=
 =?utf-8?B?bmRFb2tnWENWVGszeTVHS0twd1RlVFlKOXNtc3BhWm1uSXpISzRCR1VWMnA5?=
 =?utf-8?B?SjhROTJKT1RVaytxRlpUWnNwcUJMUWdMWXNqRGJZbWhFUmVzL1Z4STJvVHAv?=
 =?utf-8?B?SlpXZzJzYU51VUxtaWp5Um5sKzRZREZLeDZUQmdVY2dkay9DbGdvNlkvYVhB?=
 =?utf-8?B?R3U5aEZCMHo4VHZGNEFlMVQ0VGNINDM5eWJsUFVJOXM5WDNMVDFYMytXVnps?=
 =?utf-8?B?akZvRjhUWkFxUGtXUUo1UUxmTjNNNzArc0NEa0R5STFkbGZwMk91azBNVEl3?=
 =?utf-8?B?ZDVNamhhK0ZLZWo5akJTTUswODFUcndWVXVLUkhYdGtQekF6TVB3NGg5SEox?=
 =?utf-8?B?VSs3Zlo1VlFxVUl4RHJUaHhUSm1WU09jQ2dxOXdyMVpJbzRrSVM5TUVkREN4?=
 =?utf-8?B?Tkwra1VPR2JjRzhIRVdISHJEZ0R2RG51S0lzQm1IMmtSWnBjSVFzRVcxL1pj?=
 =?utf-8?B?Zm00SkF2OXMvaXR5M3l4dUMxeVo2WE9ldVJuSnNzZ2Q0aVFpWWsvbUJYVFNM?=
 =?utf-8?B?OXFBM0FlYjFMQkgrZ0NNTGg0RTljb1gyVGtIdnFrVUkyRDBpNG1TNlVTcFIv?=
 =?utf-8?Q?zPCoAKJ/jG6YUZaW3itGTtvbbFkE00AVdC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 989a4059-f7de-4e29-353a-08dbc3b0ac23
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2023 01:32:57.7101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B9+bpauKILvQx5XfawXwSzZJNECrq1XFiuCaYwziFm1Q1jx4PmVbBC4E/OtFJDkheBuRwLL913wwpU7gV2JBtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5298
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-02_16,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310030011
X-Proofpoint-GUID: 5VB25OV1ZaVBTyeoyB0cX7QbFeakgneN
X-Proofpoint-ORIG-GUID: 5VB25OV1ZaVBTyeoyB0cX7QbFeakgneN
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

A quick question ...

On 10/2/23 17:53, Sean Christopherson wrote:
> On Mon, Oct 02, 2023, David Woodhouse wrote:
>> On Mon, 2023-10-02 at 09:37 -0700, Sean Christopherson wrote:
>>> On Mon, Oct 02, 2023, David Woodhouse wrote:
>>>> On Fri, 2023-09-29 at 13:15 -0700, Dongli Zhang wrote:
>>>>>
>>>>> 1. The vcpu->hv_clock (kvmclock) is based on its own mult/shift/equation.
>>>>>
>>>>> 2. The raw monotonic (tsc_clocksource) uses different mult/shift/equation.
>>>>>
>>>>
>>>> That just seems wrong. I don't mean that you're incorrect; it seems
>>>> *morally* wrong.
>>>>
>>>> In a system with X86_FEATURE_CONSTANT_TSC, why would KVM choose to use
>>>> a *different* mult/shift/equation (your #1) to convert TSC ticks to
>>>> nanoseconds than the host CLOCK_MONOTONIC_RAW does (your #2).
>>>>
>>>> I understand that KVM can't track the host's CLOCK_MONOTONIC, as it's
>>>> adjusted by NTP. But CLOCK_MONOTONIC_RAW is supposed to be consistent.
>>>>
>>>> Fix that, and the whole problem goes away, doesn't it?
>>>>
>>>> What am I missing here, that means we can't do that?
>>>
>>> I believe the answer is that "struct pvclock_vcpu_time_info" and its math are
>>> ABI between KVM and KVM guests.
>>>
>>> Like many of the older bits of KVM, my guess is that KVM's behavior is the product
>>> of making things kinda sorta work with old hardware, i.e. was probably the least
>>> awful solution in the days before constant TSCs, but is completely nonsensical on
>>> modern hardware.
>>
>> I still don't understand. The ABI and its math are fine. The ABI is just
>>  "at time X the TSC was Y, and the TSC frequency is Z"
>>
>> I understand why on older hardware, those values needed to *change*
>> occasionally when TSC stupidity happened. 
>>
>> But on newer hardware, surely we can set them precisely *once* when the
>> VM starts, and never ever have to change them again? Theoretically not
>> even when we pause the VM, kexec into a new kernel, and resume the VM!
>>
>> But we *are* having to change it, because apparently
>> CLOCK_MONOTONIC_RAW is doing something *other* than incrementing at
>> precisely the frequency of the known and constant TSC.
>>
>> But *why* is CLOCK_MONOTONIC_RAW doing that? I thought that the whole
>> point of CLOCK_MONOTONIC_RAW was to be consistent and not adjusted by
>> NTP etc.? Shouldn't it run at precisely the same rate as the kvmclock,
>> with no skew at all?
> 
> IIUC, the issue is that the paravirt clock ends up mixing time domains, i.e. is
> a weird bastardization of the host's monotonic raw clock and the paravirt clock.
> 
> Despite a name that suggests otherwise (to me at least), __pvclock_read_cycles()
> counts "cycles" in nanoseconds, not TSC ticks.
>  
>   u64 __pvclock_read_cycles(const struct pvclock_vcpu_time_info *src, u64 tsc)
>   {
> 	u64 delta = tsc - src->tsc_timestamp;
> 	u64 offset = pvclock_scale_delta(delta, src->tsc_to_system_mul,
> 					     src->tsc_shift);
> 	return src->system_time + offset;
>   }
> 
> In the above, "offset" is computed in the kvmclock domain, whereas system_time
> comes from the host's CLOCK_MONOTONIC_RAW domain by way of master_kernel_ns.
> The goofy math is much more obvious in __get_kvmclock(), i.e. KVM's host-side
> retrieval of the guest's view of kvmclock:
> 
>   hv_clock.system_time = ka->master_kernel_ns + ka->kvmclock_offset;
> 
> The two domains use the same "clock" (constant TSC), but different math to compute
> nanoseconds from a given TSC value.  For decently large TSC values, this results
> in CLOCK_MONOTONIC_RAW and kvmclock computing two different times in nanoseconds.
> 
> When KVM decides to refresh the masterclock, e.g. vCPU hotplug in Dongli's case,
> it resets the base time, a.k.a. system_time.  I.e. KVM takes all of the time that
> was accumulated in the kvmclock domain and recomputes it in the CLOCK_MONOTONIC_RAW
> domain.  The more time that passes between refreshes, the bigger the time jump
> from the guest's perspective.
> 
> E.g. IIUC, your proposed patch to use a single RDTSC[*] eliminates the drift by
> undoing the CLOCK_MONOTONIC_RAW crap using the same TSC value on both the "add"
> and the "subtract", but the underlying train wreck of mixing time domains is
> still there.
> 
> Without a constant TSC, deferring the reference time to the host's computation
> makes sense (or at least, is less silly), because the effective TSC would be per
> physical CPU, whereas the reference time is per VM.
> 
> [*] https://urldefense.com/v3/__https://lore.kernel.org/all/ee446c823002dc92c8ea525f21d00a9f5d27de59.camel@infradead.org__;!!ACWV5N9M2RV99hQ!L3CeHeyvOUGoCmVUUQvSn86OuB-4ZJVQ8VEm-r5hq-stW5n41h1m0K9-M8GI_abiKujrexcj-5IpD74nBA$ 
> 
>> And if CLOCK_MONOTONIC_RAW is not what I thought it was... do we really
>> have to keep resetting the kvmclock to it at all? On modern hardware
>> can't the kvmclock be defined by the TSC alone?
> 
> I think there is still use for synchronizing with the host's view of time, e.g.
> to deal with lost time across host suspend+resume.
> 
> So I don't think we can completely sever KVM's paravirt clocks from host time,
> at least not without harming use cases that rely on the host's view to keep
> accurate time.  And honestly at that point, the right answer would be to stop
> advertising paravirt clocks entirely.
> 
> But I do think we can address the issues that Dongli and David are obversing
> where guest time drifts even though the host kernel's base time hasn't changed.
> If I've pieced everything together correctly, the drift can be eliminated simply
> by using the paravirt clock algorithm when converting the delta from the raw TSC
> to nanoseconds.
> 
> This is *very* lightly tested, as in it compiles and doesn't explode, but that's
> about all I've tested.
> 
> ---
>  arch/x86/kvm/x86.c | 62 +++++++++++++++++++++++++++++++---------------
>  1 file changed, 42 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6573c89c35a9..3ba7edfca47c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2417,6 +2417,9 @@ static void kvm_get_time_scale(uint64_t scaled_hz, uint64_t base_hz,
>  static atomic_t kvm_guest_has_master_clock = ATOMIC_INIT(0);
>  #endif
>  
> +static u32 host_tsc_to_system_mul;
> +static s8 host_tsc_shift;
> +
>  static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
>  static unsigned long max_tsc_khz;
>  
> @@ -2812,27 +2815,18 @@ static u64 read_tsc(void)
>  static inline u64 vgettsc(struct pvclock_clock *clock, u64 *tsc_timestamp,
>  			  int *mode)
>  {
> -	u64 tsc_pg_val;
> -	long v;
> +	u64 ns, v;
>  
>  	switch (clock->vclock_mode) {
>  	case VDSO_CLOCKMODE_HVCLOCK:
> -		if (hv_read_tsc_page_tsc(hv_get_tsc_page(),
> -					 tsc_timestamp, &tsc_pg_val)) {
> -			/* TSC page valid */
> +		if (hv_read_tsc_page_tsc(hv_get_tsc_page(), tsc_timestamp, &v))
>  			*mode = VDSO_CLOCKMODE_HVCLOCK;
> -			v = (tsc_pg_val - clock->cycle_last) &
> -				clock->mask;
> -		} else {
> -			/* TSC page invalid */
> +		else
>  			*mode = VDSO_CLOCKMODE_NONE;
> -		}
>  		break;
>  	case VDSO_CLOCKMODE_TSC:
>  		*mode = VDSO_CLOCKMODE_TSC;
> -		*tsc_timestamp = read_tsc();
> -		v = (*tsc_timestamp - clock->cycle_last) &
> -			clock->mask;
> +		v = *tsc_timestamp = read_tsc();
>  		break;
>  	default:
>  		*mode = VDSO_CLOCKMODE_NONE;
> @@ -2840,8 +2834,36 @@ static inline u64 vgettsc(struct pvclock_clock *clock, u64 *tsc_timestamp,
>  
>  	if (*mode == VDSO_CLOCKMODE_NONE)
>  		*tsc_timestamp = v = 0;
> +	else
> +		v = (v - clock->cycle_last) & clock->mask;
>  
> -	return v * clock->mult;
> +	ns = clock->base_cycles;
> +
> +	/*
> +	 * When the clock source is a raw, constant TSC, do the conversion to
> +	 * nanoseconds using the paravirt clock math so that the delta in ns is
> +	 * consistent regardless of whether the delta is converted in the host
> +	 * or the guest.
> +	 *
> +	 * The base for paravirt clocks is the kernel's base time in ns, plus
> +	 * the delta since the last sync.   E.g. if a masterclock update occurs,
> +	 * KVM will shift some amount of delta from the guest to the host.
> +	 * Conversions from TSC to ns for the hosts's CLOCK_MONOTONIC_RAW and
> +	 * paravirt clocks aren't equivalent, and so shifting the delta can
> +	 * cause time to jump from the guest's view of the paravirt clock.
> +	 * This only works for a constant TSC, otherwise the calculation would
> +	 * only be valid for the current physical CPU, whereas the base of the
> +	 * clock must be valid for all vCPUs in the VM.
> +	 */
> +	if (static_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
> +	    *mode == VDSO_CLOCKMODE_TSC && clock == &pvclock_gtod_data.raw_clock) {
> +		ns >>= clock->shift;
> +		ns += pvclock_scale_delta(v, host_tsc_to_system_mul, host_tsc_shift);
> +	} else {
> +		ns += v * clock->mult;
> +		ns >>= clock->shift;
> +	}
> +	return ns;
>  }
>  
>  static int do_monotonic_raw(s64 *t, u64 *tsc_timestamp)
> @@ -2853,9 +2875,7 @@ static int do_monotonic_raw(s64 *t, u64 *tsc_timestamp)
>  
>  	do {
>  		seq = read_seqcount_begin(&gtod->seq);
> -		ns = gtod->raw_clock.base_cycles;
> -		ns += vgettsc(&gtod->raw_clock, tsc_timestamp, &mode);
> -		ns >>= gtod->raw_clock.shift;
> +		ns = vgettsc(&gtod->raw_clock, tsc_timestamp, &mode);
>  		ns += ktime_to_ns(ktime_add(gtod->raw_clock.offset, gtod->offs_boot));
>  	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
>  	*t = ns;
> @@ -2873,9 +2893,7 @@ static int do_realtime(struct timespec64 *ts, u64 *tsc_timestamp)
>  	do {
>  		seq = read_seqcount_begin(&gtod->seq);
>  		ts->tv_sec = gtod->wall_time_sec;
> -		ns = gtod->clock.base_cycles;
> -		ns += vgettsc(&gtod->clock, tsc_timestamp, &mode);
> -		ns >>= gtod->clock.shift;
> +		ns = vgettsc(&gtod->clock, tsc_timestamp, &mode);
>  	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
>  
>  	ts->tv_sec += __iter_div_u64_rem(ns, NSEC_PER_SEC, &ns);
> @@ -12185,6 +12203,10 @@ int kvm_arch_hardware_enable(void)
>  	if (ret != 0)
>  		return ret;
>  
> +	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
> +		kvm_get_time_scale(NSEC_PER_SEC, tsc_khz * 1000LL,
> +				   &host_tsc_shift, &host_tsc_to_system_mul);

I agree that to use the kvmclock to calculate the ns elapsed when updating the
master clock.

Would you take the tsc scaling into consideration?

While the host_tsc_shift and host_tsc_to_system_mul are pre-computed, how about
the VM using different TSC frequency?

Thank you very much!

Dongli Zhang


> +
>  	local_tsc = rdtsc();
>  	stable = !kvm_check_tsc_unstable();
>  	list_for_each_entry(kvm, &vm_list, vm_list) {
> 
> base-commit: e2c8c2928d93f64b976b9242ddb08684b8cdea8d
