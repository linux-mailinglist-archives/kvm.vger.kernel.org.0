Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6CF2709CD4
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 18:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbjESQs6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 12:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbjESQsv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 12:48:51 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C29D12C
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 09:48:35 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34JFxWhv007047;
        Fri, 19 May 2023 16:48:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=YWtzEaY01HXW59oDnVV+aYmJFZBPzHblw0aMEFxyrQo=;
 b=HZXsWC/klQdqWg/xPEEvUP2bVobWufI33NHg6rqqlkpgdKC+ILJ+EhX2tw95uhRNAopd
 O1MHLS7bVzH0uybdaVepJvkIA3nZl/5TxHJXHINFaAdStllowRVtw1JEV6v3LKemtHjn
 6sbpuxbCF1u+AlG2VeuCOMgiM/KqtiPe9Uoj9avfHSv1OJLaox6fSAjfnu+g6KgqLFLv
 Z6OakxFMMZ1EgO6K4TdKqu1fE4sbH+oQWKgW3WSyzhftS/0K/1FQnIjddRR6D7SLJNVN
 yiWcBnatORBaI//BOMMzIz2nN9kjWdjMfn523dim5/qP9SM9bR6UqQN5yXBmqR4E7y8V jA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj1fcb0s2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 May 2023 16:48:12 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34JG1M0O039975;
        Fri, 19 May 2023 16:48:11 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2044.outbound.protection.outlook.com [104.47.51.44])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qj10825sw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 May 2023 16:48:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m/GZIQSOymtkHfE/876c68/5IequoTKw1ewnrvUgmb9AvMb2VChd0dVxnQjjf04hcpn6SdE65VNgJgkaEmGup1gOq4vbFoW529fhG4CF4BEHG+vHzWNSpPCZbkDaxJMSULuAbYeOJP4nLkBfJ4rGQKxhdiw2m8J5zg0vWG3cfAF42x7IT8sR6JXifgiacSEpHmap7d5B5Rkyl/6KZVPwHurV2vm8kgC5oie9ZWWJgL3EjXbT+XgKVWvJh0IivrwLLzef8b7kJmyDCBTGCMHvqYvtDVV3lbVDAEQ9DDrbZ1q9DwnWPi9MUzHyZd5pytAtiAoc39KFAHEbSgstMkdiDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YWtzEaY01HXW59oDnVV+aYmJFZBPzHblw0aMEFxyrQo=;
 b=ZFp6OnDQf8K4sSHZp2crhQhQ8BKsinmZgiFRnOs/jYnprZuPLAXEjCkxcEpX8EDPAel7sdn1e/K2ylqwPY8NteI9wv0gOQA4OZBqTtYKosru/y1DJJtmVUg5WR7A/Cl3416INijzQ1zCOsJ6jxkm7tSYL1PAv5T0H+LNic0YH6tGZ59OXQ+z01p/+W4pwTBIK1KVUXrGwvJvyEvbPjtjQqkxrIXtJg6Z8QZckvGi96bgWSuewMJNA0t5EvQ1s9U+8JLKQwwq4Tq3Fttj+ZEabwX52/2mgJAJYF7z88+AG0A91UEe83Vf1NsLrpxTHnKO9VsfYS2M63eAUsJ83G34QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YWtzEaY01HXW59oDnVV+aYmJFZBPzHblw0aMEFxyrQo=;
 b=Qlybzsnj6qVkTf3QCdrQjqkiAFqBV1vTYgvKaWm2qDK8yl7BqgKN3rZ7kkNvdaLd7qEIYLQ10h39SPxussFz4L2nd0M2raai+1XrjDr1Clytigvmh0xOLkfADqiQGPhEoiE3OvcbLMYqFzUVYlqr7PSrC1iS0+K/G9Nh5a/gLIA=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BL3PR10MB6066.namprd10.prod.outlook.com (2603:10b6:208:3b5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Fri, 19 May
 2023 16:48:09 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b%3]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 16:48:08 +0000
Message-ID: <25ca4f76-1fb6-5e17-6904-d5fe9fd6b53e@oracle.com>
Date:   Fri, 19 May 2023 17:48:01 +0100
Subject: Re: [PATCH RFCv2 01/24] iommu: Add RCU-protected page free support
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
 <20230518204650.14541-2-joao.m.martins@oracle.com>
 <ZGd6bpwfz//c0Osq@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <ZGd6bpwfz//c0Osq@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P195CA0020.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::7) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|BL3PR10MB6066:EE_
X-MS-Office365-Filtering-Correlation-Id: bd369fa9-04fd-4bee-cca4-08db5888d34a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QpuPiCslj9ph7Y6EbjFasGp9L8UokQOjmE2TIgPEkXR2JeZbPeYYxQ63JCxUWcW0nVXhJ66FmlHEKDoZhlY5mubtq0QqpZ9LnJ/a+e9z+Ml8UfpgNnOhYuWsGyFEBXU++kKyDhkBKLrYaFsLPhlD08PCV7Uq0tyBzkkTSUDR/Qn1r22KuYeWP3mlDcjUUphBFJ/4JZx3RST7ku59g+4wgY9zmPWbtgh7nzZkURYWLdrWqkZG78iIU+dURFe4m1jyQnkNZWoFDl20lKMImqQkObX7g/6ZvfzK7koJ4Tm1e/MhXxy/p0JQq/KN61yJbE6WD3Ufb9OOjyiKIJfc/a+S5Mjm9nQlxsXsyz1QfWBYCeJ9AxpzMjOueD1TPpdVzZaK5hSz5pz0+P605kvkKhBaJOPTgwuTcjgM8dydQjeiwAbmWbp63A/v7VqoZTNaT2ybzECywSBm7apJ2LZUoR2K0SpkyQC4GxFalTNEij6rvrUJ8KfQy/dZ9OFw+lYD1apeeF00OKjj9+aw/f1iwfaR3GtgAQxVMuyaTGaSl/2szMZT4IIFemMsDu5OqnVRKconN0oyYKrNgf4Z9MWxEMlow6eds+hB1hh+0USpEDyrFEd9QNcUNV5L44SvvvmVFQrj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(346002)(39860400002)(366004)(396003)(451199021)(86362001)(478600001)(36756003)(6486002)(31696002)(6666004)(66556008)(316002)(54906003)(6916009)(4326008)(66476007)(8936002)(2906002)(5660300002)(8676002)(38100700002)(7416002)(186003)(53546011)(6506007)(2616005)(26005)(66946007)(6512007)(83380400001)(41300700001)(31686004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K1VLVlpXeUNEVXNYRGNTQWxMNi9pYXNtTDVBMmJPQ1h1SHJyU2R0d3Vsdzho?=
 =?utf-8?B?V0orTFVPcHRsLzl2ak9zRkY4eUZMY0F3TmxHY200R1h4bE9rcm1uZzBjaU40?=
 =?utf-8?B?UERiRzdKaXpQdC9MWXVsMXBETzhtYndEeXV2cnYyUVVFdWI4QnJ5Rk51OUJT?=
 =?utf-8?B?Z1o5dUVYVm85dTJoNE1ycDAvUGpxbFJOYlAyaldrRWRJeHhLcXpLZlFnbHor?=
 =?utf-8?B?a2tVZm1qY1FkK2NKTkNMbndLU3ZWbGcya25wNGFPTjBVTXptR0NqeVJ4UENP?=
 =?utf-8?B?ODlMK2E3RmhXbkxwQjNXdGNYRFpqVThDRG1IK2VLMFBVYTZJMG9oN0QzZDIz?=
 =?utf-8?B?di9WK0lMSHFBVElVUVYyVEp6ZGUzOVBZVHhJRWpycnhEWWZFekNlb09CbTdW?=
 =?utf-8?B?cHF5aHVIZE1SR2pjaEdhWmE1d2dvUDY5YkRRdE54aERLVzFRTC9WZWczNDFk?=
 =?utf-8?B?UE1tTkRVOE1qYTg5UjRiL3YrT0FPQ2VFSEIwSDJUMEdrOWpDaldmc09ReS9j?=
 =?utf-8?B?ZXE1VjV1ekQwWnZDUnpQZ3ZiM0hFRjBxeTN0dlJlUVpBeGgxN3pSVytiYVVQ?=
 =?utf-8?B?SW5JbVpia1VkOW9pYWNnZXNQK2V6NE1Zb2ZUNzloU29kRXByQ1J4RWd2TXM2?=
 =?utf-8?B?ckl4ajl1ZklKV3lHNzdOTnd6TTlZbjdIMnB6UGFCd1JqQ05CbExqMTMyTUtU?=
 =?utf-8?B?a2lkVWJ5OGliaDJnR1p3bXlQSnRXZ3hTT1kwbmxaVGFISnZjUFJhVU0xSEt2?=
 =?utf-8?B?S3hTTVBvdjNyWlV3Z1dieGxjL0NCY2hNZzdiN2t0c0piZHliWnN2cVBIRURW?=
 =?utf-8?B?UWw1WElkQ0VJdXZleHZRVFlZajV6V3VWRUcxc0MxT1dGQVpXUnJLRmJLS3RY?=
 =?utf-8?B?YUU2WWh6dGNyRUtuUko0TWMrTUE4R0c4OUxSQy9tZjZ6dEJHQkNHZldEM3d6?=
 =?utf-8?B?N3BCNDZJQ0VzV3IyZis4NXQxYTdDQTBrQ3I0VjlrWmJJWVpBUS9VQmRmTjVj?=
 =?utf-8?B?ajBZZXhiUmhzcUNnaUkyb2NYcGU5dWx6eG5FQUZ6aHBIOFlDaDRsNTFtd2lN?=
 =?utf-8?B?M2tha0FHMHlUOFdkOEp0WkR3TmZMWEdDQW5oRnd2UWp3eDRpTldVTTNETkZJ?=
 =?utf-8?B?OVNYVHJJcHJ4UVBEazJQMmNlRnM1MC9WMDBaU2RwQVRDN25vaVVWSk9qeGo1?=
 =?utf-8?B?QXRXbldkdnE1Q2lJTkhFZFBaaitzSEJNY0hxUFNycXhoeTY3cHpzT05Ea1cz?=
 =?utf-8?B?V2VpMUJ3TWNPS1RxRXRwVGtUQ2lWTGd2VjZUakhXL0tBemVGQ0RvN21QSlFQ?=
 =?utf-8?B?T1FGeVdUemNRM1loVGVIYnV0dmxXVHpjUTJhSjk3ZVFkYkxmRzMzKzYxWmxN?=
 =?utf-8?B?bGtaU3FMYkpCYjFyK2pvVmt6OXlvN1FYMkFCeVBPRzZYMktOOFFLd1hIZ2xR?=
 =?utf-8?B?cDRUODVZQ08xODYzcnFnZmtRb3FneVNlKy85TVBJeEVYMDhwVnFWOUMvVzk5?=
 =?utf-8?B?LzE4dmNDME93cW9VN3ZEd3M2NDRsbGZoMWZqN3dpaU9QWXdadTVta0lUT2Yx?=
 =?utf-8?B?WEJFZHVQb3E1K3lOL3VrcXdiWVRiclFIcEdGWVZqeHBjbkx0b1pZZ29lcDNV?=
 =?utf-8?B?S0FINlNCU09MWjVzeDFlT0NRSy92S1hvdFNTRWkxa3NxVnYvWU5iRDFWVWRK?=
 =?utf-8?B?eFZEZGdEdFBTQkk5ZktERzF2TlZKbHdFL2lMS2JhS01kdDc2NXNqQmpRcWVB?=
 =?utf-8?B?VlN3TnhPSm5oVjBKQ21BN3ptdURBdkxheitDdHZab3EwdnVtZGFpaWd3R3BQ?=
 =?utf-8?B?d2dwZEl4Tk5PQUxmaU9wK1d0Y05NdHhoT0Q4dXd3eUdDL0F0SWlRL21PQXdy?=
 =?utf-8?B?SlZvWEFDU1NCZEQrKzZ0cHR0dDJVOU1iNHBDbzNlT0ZTSU5vaHE5a1NRcE9z?=
 =?utf-8?B?TVhLZEo1VXUzZGV0Wjdkd3ZscGZjZ1VXQXpRMzBrcFpod0h1QWpNTGxkbWJl?=
 =?utf-8?B?cTBkenN1Q2hTWTdZNVd6aS8zQlRyRTJrQS84RWdVeXUxNWVqdWFrK2h6cHJj?=
 =?utf-8?B?WStZUTFYTGZoZXQ5WWw0eTlCRWpUR3UvS0lMT1VIcG5SL0VRQzNBVmdXUzN2?=
 =?utf-8?B?RXNuY0xNRU4xZm9SdzRuc2xDc2tkMmZQV0VXRzNjOTgwS2ttM0hXVVJVNVZn?=
 =?utf-8?B?QlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?TXBFN1BWMmVicW5tVktCUnh5b0FnODY4OVM4MUFmM05tL2Rqa214OFYvcC9O?=
 =?utf-8?B?ekQ0MWRVVXdRc09Mcy90WSs3dUdWNmpDMUx3eVphUDUxR1l4VmdqekQrZTJo?=
 =?utf-8?B?Q0t4Z01xNEJxWDBFZjZmbjg4MFlleC9zL2xoOUVTMjdzK0x1TitQT2N0U0cz?=
 =?utf-8?B?Vy9sbGN5bG5OV1ErNUF3a2FiQm5KREdrOU1EcUwxRVdZUWYzNXh3RW8rZmFX?=
 =?utf-8?B?d0N6M0xsUFRidVk2ZnVMZEU4Q2tyVXhJTEJhZXlBTnVyWXFacWRjYUNWTzdX?=
 =?utf-8?B?bnhPQ3pKbjFqV0pIN1FYY3YvanBETC9KMGpkWGZqQnRyZWxZUE9LeEg0WmhC?=
 =?utf-8?B?NHB2RVRLU0dJNWpzd3hPcFFxc0JoL3MwR0JYa2hLQnd2N3dxOWl0djcySFda?=
 =?utf-8?B?U1R5WlQwY1RSL3ZiZWgzOE9raEUrUDE0NjRtNk9LakZPS0hjTXg1Q01wc2tl?=
 =?utf-8?B?V0JRQ2NOTStVUVZSMVBSMWdKcjdZSHVWNUhpdWp1bStBb0dPcUtJdGF4QWtO?=
 =?utf-8?B?ejNXVGgzMmt0WWlQRWJGZlMvVXhwZlErMko2T1dJZk1DYUt5WkJ1dGIwczVB?=
 =?utf-8?B?VXRoRXV3MWVRWElvM20vT1RpQVlKK2N4MlA2QmRzMVg4SjE2d2p2bXFhUzI5?=
 =?utf-8?B?RzZaM3F0TnRadnlnd1lNR1g5QWVtYzZia2hsdEdwUW4rT0k3eE5Nc2Vta0JB?=
 =?utf-8?B?cy8vckt1UEZWbmpnNWdFMS9qRDNzZ1RhV3BQUlRUR0hrSkthS1ptekVLSVFw?=
 =?utf-8?B?SUxEWVdaZ0ZsRDRGTWJKSEk3aCsrbFQ3VlErRG1sSGRxL0E3KzM5L3dzcUox?=
 =?utf-8?B?RUlNSDV0Q1VONldUd2drZTljOWJkWW4rVjZZVVRCOUFSVWloRk9yZGRNVE5i?=
 =?utf-8?B?VllsQkFFRWtESDVxMVg1MGdZeHNoSU9qR2RGV1hmblJvZzhGUTQvM3ZtNk9K?=
 =?utf-8?B?SlVGOVpwMkJrUFZzRWdFQ1ZwamlHaHVlM1VpSUk3MlhGWVhSdEVDVjVPZm1m?=
 =?utf-8?B?ZHNRZTJaL1BUMlNjT2lGSG01a0swRVEzRkc5NXprVGlzOFBuTlpjaE5tTW5Q?=
 =?utf-8?B?OFF1OFQ2RERxeTVEY2cyS1oxM2NENVZNSGUvVm90NHlMK2VNYnpaZjhBVG52?=
 =?utf-8?B?cXF2YTkrSnA3RmxvVXNKTVFudk1kZlRLWVhlNUpGdmlQOGg3NmRkMi95cVdY?=
 =?utf-8?B?MHFQRi90dUJnRkZvWURhME4rM3ZxT2pLZExoSGJQMVB5TFlROWpTejdacWhn?=
 =?utf-8?B?NTB2bUpkM0V6YW1TM2pCVEd0NlNnQ29BemNJYUlJMzRUajJwRm1hb0JaNUV2?=
 =?utf-8?B?cyswdGdWbFBkNjVUSGh2WXhsNUhlOHZQRTBCYnNhMzFSMDJ5bkxtdGJoMFRx?=
 =?utf-8?B?ZENhU2lidzN2eWh3dHVHdW5WNkQrSHNkWkxUVjE5My9JNWR1cVhEZzlZVjEr?=
 =?utf-8?B?Zkh0bDgvdm5BekltY3NLVkYxK3BpOUJYTm1aK3pnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd369fa9-04fd-4bee-cca4-08db5888d34a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 16:48:08.8365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pb2FSMIA0LO4NNtFWJXvAiNzCwiaW3fnEwcdR4Vi2EGhZizl20OtY1Zr5osMuRS4mQTSzjzxzXHb+RRQauhEeIzhgMWrV7scrX/Ga8MsNA4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6066
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-19_12,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=723
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305190143
X-Proofpoint-ORIG-GUID: nw7-RJfSL-zRgJttwUa-hqNrA-NbynJ8
X-Proofpoint-GUID: nw7-RJfSL-zRgJttwUa-hqNrA-NbynJ8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/05/2023 14:32, Jason Gunthorpe wrote:
> On Thu, May 18, 2023 at 09:46:27PM +0100, Joao Martins wrote:
>> From: Lu Baolu <baolu.lu@linux.intel.com>
>>
>> The IOMMU page tables are updated using iommu_map/unmap() interfaces.
>> Currently, there is no mandatory requirement for drivers to use locks
>> to ensure concurrent updates to page tables, because it's assumed that
>> overlapping IOVA ranges do not have concurrent updates. Therefore the
>> IOMMU drivers only need to take care of concurrent updates to level
>> page table entries.
>>
>> But enabling new features challenges this assumption. For example, the
>> hardware assisted dirty page tracking feature requires scanning page
>> tables in interfaces other than mapping and unmapping. This might result
>> in a use-after-free scenario in which a level page table has been freed
>> by the unmap() interface, while another thread is scanning the next level
>> page table.
> 
> I'm not convinced.. The basic model we have is that the caller has to
> bring the range locking and the caller has to promise it doesn't do
> overlapping things to ranges.
> 
> iommufd implements this with area based IOVA range locking.
> 
Right

> So, I don't really see an obvious reason why we can't also require
> that the dirty reporting hold the area lock and domain locks while it
> is calling the iommu driver?
> 
> Then we don't have a locking or RCU problem here.
> 
I would rather keep base on area range locking -- I think I got confused from
this other thread discussion on having RCU for the iopte walks. I'll remove it
from the series for now, and if later deemed needed it should come as a separate
thing.
