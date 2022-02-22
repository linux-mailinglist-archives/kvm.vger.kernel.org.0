Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6394BF189
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 06:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiBVFij (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 00:38:39 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:52316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiBVFiZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 00:38:25 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D1D95486;
        Mon, 21 Feb 2022 21:38:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Obyq5k4M0hRUFK1hAiZe8KaA0IA6dXmrPKCDPJfO+M0+PEsSgQo20/nbtAaHyNSTbjHcD04pR7g7dIWmdMnz6LBb2jaVQVr8LGFXOj1ociD20H8zjyTnmM+6txbBOeol+U6kyXD8X7fR/PXGSVcE6Dnsn0G+36nPhuzdh4DG3KKiVLQz7qbFLVBhOc6NgNArHv9S9f3ZEeb2oJw7jeagtDaH2+STO/RkdqNgsAOMoINUZUFie46JxKxmbCOw7g3vCHyoGfnltLuhu94JIRTKuSAlE356v+0t7oj00u8LTyyqmxzR/tCkaEF0XDgUy5kxHvbKZpoF9rtBS/3TUkhaeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=60kJFzkzpRmJEZSKjP2nWZDYW1YlCU/i24TTHL+fzWg=;
 b=Gnz/DjcwuiuO0e4jevra/6/1/Wne19HfcyS7AZpfULN58fD4GvlnuwVgOicYSCCalav8z9T2kuDdxY7c4+DbUMtWfsTVih6rdpU3ldXQOivlLYjXrdpb53zBee5p0pxNQvVzzfEhvs81Xj5+6Jx7ODgynEcZGzzQ3HN6MDgcnaCw0n3aqb0VAcrIpevcenyFcTk8OnKZXCAjYLloKD6hVO9bKwAYgIm6pEqoWKtU7/vaqYvhNJjS6KBhnDqdBYjODyxx/adXcn6UDLKb8/QPCyP68M3dUAw7r/D12apTYSk6hiH6f3fO6bKxAJsY6FrbTxjqDmf3i/r/nV18ZQJHDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=60kJFzkzpRmJEZSKjP2nWZDYW1YlCU/i24TTHL+fzWg=;
 b=iMazQ9/jNw3sCjENOSnXxK/fWSeYDox1nq6dALZOnfkl65OOJbBIOveIm+pry6x5KfmocsN9aWoDaM9nZMinsuuGnPrAuUewet+UFK9xVkuKyW3j5sGXQaAGcLMRvbfsuCbZe3+CkRNWcF/N8O6yZe07k8/wOHdLW1Av4DFrliI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 BYAPR12MB2663.namprd12.prod.outlook.com (2603:10b6:a03:72::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.27; Tue, 22 Feb 2022 05:37:58 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::6807:3c6c:a619:3527]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::6807:3c6c:a619:3527%4]) with mapi id 15.20.4995.027; Tue, 22 Feb 2022
 05:37:58 +0000
Message-ID: <6f207cb1-307b-2759-3b03-eaf015fdd3f4@amd.com>
Date:   Tue, 22 Feb 2022 12:37:48 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [RFC PATCH 00/13] Introducing AMD x2APIC Virtualization (x2AVIC)
 support.
Content-Language: en-US
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR02CA0133.apcprd02.prod.outlook.com
 (2603:1096:202:16::17) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a22b507-db04-4619-7bef-08d9f5c57b53
X-MS-TrafficTypeDiagnostic: BYAPR12MB2663:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB2663CB992A04DBF68E75C296F33B9@BYAPR12MB2663.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OHa7c5/NF8+sVg3bU4te4y+C9ZQ/fH5OzpzLKDgfFHfqdXU1dBazbzkwPYFV4621GWpKZzMWE18oxIzGYI0i7zZObZGgzPb7ToF+uTWBN5MhF0T0Cd2eEKiaGfvYfdjx1ItpLagSQ1kvwl/ID13rp0w0P0ce+dsqYd8UU3cfKHqwN0wnC7Abo69iG6kWMTSBmci2NY9/Z19ZFQiNW59SFtiAf3ejNDVDrsP73TJhakGYA9Voo2CVmyuY6tXODO47XhgVkIllvKiQgf6oWz+B4tQxF9PUg4Z8FLm3GfGxyIkQjQfMl2qG3/8z0KWTa+PSDCENNVxh6NomJoTi6uU8tgmhHmygIPpASjMsT+bASaFViQCAe69DY7+5DX6A1ffJRXP+9w29fa+jeKqsnN2pxEtnnxVE5APNu5TUuseC6ur/xGxgIjfYMEOmx2BpY4cSmCmOJsle+nApgL2wOy6YmHVMvZUrfs8ZW9H1HHjy/RlPHxOf3Ck0TcWhn37+xOoetkgtBiAtuthZw24iym1e9PNxgm2t+hbwhwDlK1M8RIXfQq+c9rhL0lIvU7I38l40RgHMMlHzMR6qoXgygJa0YoVHxO2nzij8OADZlE+ODOTN8XDRxAsIePnX8mqtEdUQIT3FIjgrVAuf6V+bCso3BahVUuFZevp/mXmkpf+W983OOLX2OHj+fVrN4aimLCxP0oiDXLAOu0lVUFFbkvcYyFMoBr2D4BFK0KJJjqjEyOo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(4326008)(186003)(26005)(8936002)(66556008)(66476007)(5660300002)(4744005)(83380400001)(66946007)(31696002)(316002)(86362001)(6506007)(2616005)(6486002)(36756003)(6666004)(2906002)(38100700002)(508600001)(6512007)(53546011)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?anZiMk9EbjU4SUhnZHRxOGdKQkhBaGZHMlpRMkYrbjk0eEEzV3lWdWJBNVQ5?=
 =?utf-8?B?VFRTZW9qM2oxanNsck9MMFFGODVwemZ1dGEzS0xNSU5IWVgrVFdtOFdZNU9L?=
 =?utf-8?B?Tm9WZEM2N0xzbFg1a0hYWUFSeFJ4QWNySXB0WjF4WThTaTdUVVlVaXFWNUhP?=
 =?utf-8?B?SDFOMUNURXdWa05QSTRoU2ZJKzl6QWNjNWVmVUwxeFhtbjVtQ0EzbGFwMncw?=
 =?utf-8?B?SU5Iczk4aWc2ZW81ZkJ0L3o4QnJ1b2R4WGlmTThmaU42VUZZdHhsTUVEL1Fi?=
 =?utf-8?B?Tmd1QlAwN084WGUwTUVGUHU1ZVd2UWtTaDdZVzUvT3V0Rmt0bmZrNVJqN1NB?=
 =?utf-8?B?QW5IVk5TWUNTdCt1eTlVdjJ0VjJncWNXdENJeGFEUHMyZjZOdmFPSnVld3JO?=
 =?utf-8?B?KzVKUnBmVFVaUGF0V2RBd0s5L1IxbFlvSHBqa2U0b3ZsYWlwL3hZRmpsUkJL?=
 =?utf-8?B?eXhBSzJvNUxFVmtMemxBbFJsWnNlcW1oaGZwMVBvODRMeVFLcTJxYVFMaXRu?=
 =?utf-8?B?Vk9rYkpxajk4Q25iMm9qRWk4eGlFWVBJOXVCMXZJa0hSM3lEKzNUbWVEZS9z?=
 =?utf-8?B?MlAxZFFCRWhldTFnSDM2V1VsTCsvcWR5Ti9URlBHYUpLWmVtYjhQSEs4N3Aw?=
 =?utf-8?B?NG8zRlVUT0xtWkUxNU8rWU44NStBZGRFcDM5U3oxUGlxYlJaWjAwKyt3KzZi?=
 =?utf-8?B?YTBSdnJnVHVZdnRBNXB3Qm9PcTVaemZCb3JzSXUwTktxejRhVGtWT012MUtk?=
 =?utf-8?B?d1pvTTNQc09oWUFhVnlKVG9nUHhLc3ZicXozSUZXNUpXQjNhaHh2eUt2TTVW?=
 =?utf-8?B?cFVtdmVlWDJuM2FmdnRzTCs0OTArWmFNRFNaZGI3NkZIajk1NG5EU25qMS9o?=
 =?utf-8?B?WTBvMnZLQk1OdWpQcmNQL01YSDY1dHpIV0hqcGhkR1dZUGZSQjFyS092T2g3?=
 =?utf-8?B?ZDhITE1kRVNpOTYzdFJBSjF2Y20xeEJzN1l6bGh0VzQ2K3FOcHFXa005eW1Z?=
 =?utf-8?B?Wng1SjM1VzByOHBWN08vdTVIRk1Lcy9odDFBa05zWnNWRDN1c1BhNytVTlhR?=
 =?utf-8?B?WDF6L2p3MSs1bXM5dk9OTVMvcitBMmM1bTlwY0NRZ2llY2kyVVJtTWVib29p?=
 =?utf-8?B?VUYzdzVWODM4eHdRc1dKNlpHQmp2bHphVGRlQTdHM0ZvVitvaTdsMWd3SXNS?=
 =?utf-8?B?ZGkwZ3ZodUdXNlJUNGNNdHMvT0daOTFyK2dHQ1U4T2gyWVJWczNkQlFsaVhS?=
 =?utf-8?B?N0JYYmlrWGU2QkZOWHJLK0g3UEQ4N1dydlpSR3lSUlhHeERZSFhRUWk3UkNj?=
 =?utf-8?B?M1RJVHo5NnVTRHRVMGNjU0FTNGtTVDIwSkFsaDh0UVRlSjJrcTNtdTFRbWky?=
 =?utf-8?B?aUNnZVFlNzAvZTU5d01zT1lvVXg4VitPUWc4NWI4dit0NHNOemU2bmtHZmFn?=
 =?utf-8?B?N3VKNlROZXlncEgyZjd2anNwMkQ2SHB4a0RGYVhqaEFFNDBiV3VRaUo3V3ZT?=
 =?utf-8?B?TXFhWk5WVCtUZk1GakhkUWpJRmFBV3lSQkNPeENud3IxVVQ4SURMY282aW1t?=
 =?utf-8?B?eVBrMU9Zbkl0UlNUSW03bEJ1d01RaWNvYmUzdnJmQkVPVC9NWitXQlRMS3Rt?=
 =?utf-8?B?S2orRzN0MTY0dENSaDljcXdhekVDUkNlVU9kZVlZT2NDUHhMV3V4YWU4T1Jy?=
 =?utf-8?B?bElldUdaRHBhOHhxaUpzZXB4eTRsTlZ3UFlGNUcydFZCb0szeUNjNmFnWmYw?=
 =?utf-8?B?ckFhSnh5dVhlbm5QbWRVaVJjSGxkTnNjVVpWb2RPSGM1eElTaHlPcnhWTFdK?=
 =?utf-8?B?R1dodWhJL0VPVCsvT3lraEJaL3FWVGQ1cHdTMDhyK1BRVk5BNTIzN1Y5RW5D?=
 =?utf-8?B?YUowcnkyckdYb1ppV1JtclF1ZFdwYk1aYzBPMmhxbnBDR1RySjR1VWVHRjYw?=
 =?utf-8?B?ZjdBenoxL2hEaU9paXd2QjFYUUVLM1pXbVpCUm9ScTFqYnRHdXJOOW1tWmVu?=
 =?utf-8?B?d0Zrb2xwWXJ0RVhzMThuVUszWEd4S2tkeUNkdmJ1RU1OQzVaTkRIdUdTbEN4?=
 =?utf-8?B?Z0lnMlhNdGFlR0RkczAxcHQyUi9kMHpCM3orbmJGYjR1bFJmYVJJVnZGTFpV?=
 =?utf-8?B?ZitaaTBMcndIeWZoY25DMWp5bWpzeTBTS3BqRmdzanV0R0RzNjFucEFwZkhS?=
 =?utf-8?Q?6gimAKhTA3hTcOjjq7SY63I=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a22b507-db04-4619-7bef-08d9f5c57b53
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 05:37:58.0598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3q0o07OrFb1byFNhnW1tO+/w2kkzk9Nkx6aozeUDNVNshPhw3DZHZHGLvCjN6XYUyp/3E9FR/MIj+EsJhxULgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2663
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/21/2022 9:19 AM, Suravee Suthikulpanit wrote:
> Testing:
>    * This series has been tested booting a Linux VM with x2APIC physical
>      and logical modes upto 511 vCPUs.

Update:
   * This series has been tested booting a Linux VM with x2APIC physical
     and logical modes upto 512 vCPUs with the following change in QEMU:

diff --git a/hw/i386/pc_q35.c b/hw/i386/pc_q35.c
index 797e09500b..282036df98 100644
--- a/hw/i386/pc_q35.c
+++ b/hw/i386/pc_q35.c
@@ -352,7 +352,7 @@ static void pc_q35_machine_options(MachineClass *m)
      machine_class_allow_dynamic_sysbus_dev(m, TYPE_INTEL_IOMMU_DEVICE);
      machine_class_allow_dynamic_sysbus_dev(m, TYPE_RAMFB_DEVICE);
      machine_class_allow_dynamic_sysbus_dev(m, TYPE_VMBUS_BRIDGE);
-    m->max_cpus = 288;
+    m->max_cpus = 512;
  }

Regards,
Suravee
