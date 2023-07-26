Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 901B1763D45
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 19:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbjGZRJa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 13:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjGZRJ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 13:09:29 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2129.outbound.protection.outlook.com [40.107.15.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED151BE4
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 10:09:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dr1VFeLlQmt9Am6j1ird94Ll91kqbUWRs4o3aiWn5i1MBVvCQPEak+7zkX+lB+nrS8Wj6nwo/Pzrz3UpxLBmVVGJqsfQEpu2CSVA6B466E5xv8GBtrn+6OaGiv9LmaeY4mbwJZG3GJZnk7XiUDJWCcgxKn62/ceZsrCv6YucfXay4ke979C8hYrRfgou9uDuWf3BFLhXtV6wk+aRNnKxpHPMGSzgsuEK0fkZ88zDdKM1z8PN6AHd5qhzhWdO/s2B2R9PfiB3BrbeI23XNyOXryG+uo958E5bCQv0YSM4Pd1aF8Wq0XbPUoJAJuYJinkf/t3yt4aA6nvj54wHm8yP/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W/DsGVlGgo+sqbtBkL2pwxSSOInq+TZp33CMBcHtODw=;
 b=Kze6qOL3YaMTNOrwU3ePwCMktQCU1tCC3OmwnJxyucYOiM3BrSr54YBEwl7uJ2cDKm6AUeAokZXdbIBoryx344kW2Y/DEtKiQdbelVRRi6l3ct/86OUdoej6WGk5Tywz7OeARzUYDFFvtUHIg4saiQGFODZuPpBo7z/+nf1pl+Ktl8kzSpfciaYGT2B60//vZcpGoE1miyCdbNZZfyiC3S2sSaiW5yGmae0xLFZdcnA3qYZiF9BWLJx8E5VJaD0lixeg00SiQOMU1ZRkJzuK+dc8sqSjtJI6Wt7RvTU7sLwWuZY4Kve7Iz9Y+ie9ugf0wLcOC7uwLNpm4qHQaew70w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=polito.it; dmarc=pass action=none header.from=polito.it;
 dkim=pass header.d=polito.it; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=politoit.onmicrosoft.com; s=selector2-politoit-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W/DsGVlGgo+sqbtBkL2pwxSSOInq+TZp33CMBcHtODw=;
 b=ODwENd6evxunDnXvmY76PC/17ORoEAVUY9zU4PCsUNUiqavE3eBPQgcq6w1lIRWRyakT6wkC6NfXOKp4ZM3lWlpSxrDQq9rDe7bAs6pFdRnfgHSP4kbBnPF3ROkV+sWW/q9JPv93Fa+bcuysHCr+xasJhFlj9bAYIJoumXyi28U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=polito.it;
Received: from AS5PR05MB10944.eurprd05.prod.outlook.com (2603:10a6:20b:673::5)
 by PR3PR05MB7291.eurprd05.prod.outlook.com (2603:10a6:102:91::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Wed, 26 Jul
 2023 17:09:24 +0000
Received: from AS5PR05MB10944.eurprd05.prod.outlook.com
 ([fe80::4730:8f0f:3286:a07b]) by AS5PR05MB10944.eurprd05.prod.outlook.com
 ([fe80::4730:8f0f:3286:a07b%7]) with mapi id 15.20.6609.032; Wed, 26 Jul 2023
 17:09:24 +0000
Message-ID: <65262e67-7885-971a-896d-ad9c0a760907@polito.it>
Date:   Wed, 26 Jul 2023 10:09:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US, it-IT
To:     kvm@vger.kernel.org
From:   Federico Parola <federico.parola@polito.it>
Subject: Pre-populate TDP table to avoid page faults at VM boot
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWH0EPF00056D16.namprd21.prod.outlook.com
 (2603:10b6:30f:fff2:0:1:0:1d) To AS5PR05MB10944.eurprd05.prod.outlook.com
 (2603:10a6:20b:673::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS5PR05MB10944:EE_|PR3PR05MB7291:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d731fa8-e05e-4bcd-f243-08db8dfb0f49
X-POLITOEOL-test: CGP-Message-politoit
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3SttSc3F+yad+nZvWji3kdafsJPSzzhhWLodGc7vZccl0R3OUl8m519l2En6RRFf202nNyWy2ifnT20a2BvN2SUvAH0s+Mj8hfVlyujf28XeKxolrx6PXmT1Rh2qV5j7m2/rPpMKZNLVJXhZVhFy0pUpALirBC1ZEFh6K3i1UeefzCFn/SJ7C16K5+dsQFlQpYCkrcXfrB6qwk7ldHkGtM35h9oQx29+ZRa/uBv0Fq/CNYEqllhPlNGeDJ+EfMolfiww39BD0/ANlT+kGkO6vBEVs5/u+VMX/n5DNngT60iZ1MDJTkeT46h6eohRLqivgDgbIw5AqYuHEmXbK0kvePX3llhxTWqjEHopX7116c+VVnAycgmzy6teYQRI05FLLHKeUUDhIqFdlXP1S0cx4UiBYjbtx+7jsRoGw1aaUbCmx6CuLi/n/kVYmBbHI4KpZfbQ7XNV7P7mVwciM9hRqeJ0uGRAoot53PXikO1YQ56w1FL3We3MWbZoyQEMy4DfL67GrEIMSO7HZwubuqDkbNWn/OXxnE/rOHb/sLteeS7jy2+zIq8Or1U/X05Lc3SJh2rZrkRZRKia2jp4jErHHqPyhTdB+gY2PBqK/vejyPd70PibtAqnrjiGJgnDcnXJv/apFhxFhRMeIobfOVjrHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS5PR05MB10944.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(136003)(376002)(366004)(396003)(451199021)(6486002)(6512007)(6666004)(478600001)(66476007)(2616005)(26005)(186003)(6506007)(2906002)(4744005)(66556008)(6916009)(66946007)(786003)(316002)(8936002)(44832011)(5660300002)(8676002)(41300700001)(38100700002)(36756003)(31696002)(86362001)(83380400001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cXI1VmJ3enJvdXk3UHNoQU9LKzkzSjBsSCsrdlUyY0RLYXd4UGo2R2g2eXJn?=
 =?utf-8?B?MEdxU1luWkFrREZDem52a29qdCsxTjdzeE5ZdmxlWi85M0RUUGdaSHkwdVJ2?=
 =?utf-8?B?MHZ5dWRHTHlESFRkTTFDOTlhTTNhZkttMFN3bGdKbTc2b2FyUHh6cjlzd3hO?=
 =?utf-8?B?a3liYWRnQ3U3S0NnUHpBQTI5UlcySUQybDNuREU5QjdWS1NkUE9jUkJ4ZXZ3?=
 =?utf-8?B?NFhpRFZVSjhzNHA2aHFYaDRLWUdGWTNqN1VDemhCa3dTMTNSei9zVlVib2xr?=
 =?utf-8?B?NjVhenB3UFREanVEZmFjRGF2clpGVk5XMWVVRUtYakpMN2hFU1RzcG9mV3Bn?=
 =?utf-8?B?TVRZaVFKVjVQa1BwSXdmMkh3NFlLWGNRalJTNCtVT2s5NVpndXR0eHVnTHJ0?=
 =?utf-8?B?NHpuZ01IMXJ1eXA4dUFPeHdQRSs5eHE2ZnU2WFEwN3BrWEp2OVZIU3FoUm1w?=
 =?utf-8?B?UFhaMkNWTFplbml3MTNKWVB1NU1zbGhGMnhaSS9YUTFjRDZaTXhYYS94L21v?=
 =?utf-8?B?THZCNTVETnlqVGYxRDBmOFQ2ZEhjM1Rvai92M1hDc3RQdjJIWCtlN2xZVWNR?=
 =?utf-8?B?ZnFGMm5hOFZRUXNCcjhPMFNFLzNLY29xZ0h5QlhmeWp1VHlncGZCSm1kUlRP?=
 =?utf-8?B?R1dRcno2WUg1cmQ2Tlg3MFI0eGVKTjJ4eFl5enlFN0ZJWWV4anpCejVTUEl3?=
 =?utf-8?B?ZXJhWUlLd1JJWlJnNEpVQ2RucmpxQ0RjVjJUSkYweXlmbnNaYkJsdTd0TGcw?=
 =?utf-8?B?Z29LY1VwT1kzcjhUSW9tTHk2MFNoMWJNOWZhVVpOd0U2eDJWYTFseVdIaXdG?=
 =?utf-8?B?bWVQdUVmNVpNU21ZV0JlNmZUNzloTUc2ajZEemJpU0YycnAvaDdLSGVlVFRa?=
 =?utf-8?B?UUt1ck8xMlhKbENDemNOMmVxcnZCZmhQYy9HQitDRVl4Mm9sSEFNamdubUFx?=
 =?utf-8?B?OXpYeGlHb1c1SkFFNDZ5MVNEbkZjdUt5MGdHUUJMZHZaRm9QTm9GL0RNdHpo?=
 =?utf-8?B?eHF4SGo1Tm5tbTF5OHdMZ1Z6S05FTWNZNFdGMVg1WHdXRkpNQndYUDh1MlNU?=
 =?utf-8?B?UmNxNjdSZU1DYks2U2ZYTzFZbXlmZHYxR3JGRUJpbTRwN3RVdnA4RDZVeUJP?=
 =?utf-8?B?UDk3Qk1hZ3dqWElVLytJQ1FzZVY1ak13Sjd5bUE2N2hKYnVvQjJzV3V5K3U5?=
 =?utf-8?B?Tk9YdkpTWTRocDluaU5TNmVtR2pTU1FFYlBRc1RKbUFRYTlKR2ZZT0FidW10?=
 =?utf-8?B?Y0tWcXFYV0orVkJZWWMrS1ptdzhnNmhVZWVGdmVSTVhtbjVDNDhhSWxrNWJK?=
 =?utf-8?B?b0doRUtMYndCdFJxYytKVTc0TEhKWU9uQWZuUlJGdjg2VnJVanRMU0NBNDVN?=
 =?utf-8?B?WURiMlZjUDgvcHZkSVhYZ3djV0tOK1Bkb1dMWFhIWXVMenNvZHRJVWVOQWdh?=
 =?utf-8?B?aUlLZnhvWXBpdjRBSnkzc0FRQ2FENzY3RFIxRm0wVUVJMDVsSTgxL0l2WGY2?=
 =?utf-8?B?MkZoOWxIc1B3NktmbWMzQmhYdnE0aWhXQU9JblNqeGVaS3lCOGw0MXI0cGNl?=
 =?utf-8?B?QS9QVTNaNXRCK0JZVE9CMEM1ejB1M2NiQXBnbUk5NStmbTlBQ2lGMm5CeGRE?=
 =?utf-8?B?UFZDazBvWG8vN1czRFU5MGt4OWp3N2JlV002VHIvbUFVOUN0NTg1bzEwNVNl?=
 =?utf-8?B?a1ZBNGNBNkRYUk1hUVZNT055U1VCbHViQ3ppd0ZZZzF3ZmhYWG11YU1WUkMx?=
 =?utf-8?B?QlN1V3ltb2dzODNOL1VZUzNZNllFRTlwbkdLZlp0VEhzUHRsN2Y1L1d4Uk5G?=
 =?utf-8?B?aDFUWkIxQ0FJTG1jN3lTUUt1aDNBVEIvQ2grNEtkQTR0ejZNbndTTjZ0ZmpQ?=
 =?utf-8?B?S1hia1VWa0ViQW51RHdGQ2YvUVJJUHhKNVcrSlNCZ1NxcGlGb0NsQXhBRGEv?=
 =?utf-8?B?ekFld0tMYU50cFV4a0hKeVlVZWllSTRKNHlidmUvTXlaRXhGMmI3aUNOb0dH?=
 =?utf-8?B?OGJPR0E1ZkxBaDdTamtJVGNWYmV5eXg5R05HdFVtM1gyTXEybzJVNFp3V0Jy?=
 =?utf-8?B?TWpNM2tlamRjQmErbG9LcXdXd2VHMkdnTGNXUXRDV2xVT2Z2cU5wbThKZS9t?=
 =?utf-8?B?Q1FpN1ZXekJmWE5sYUJKT1dYblJxUjdwZVpNRmpkcjI5YzVJSzRFSjR1YzlI?=
 =?utf-8?B?eHc9PQ==?=
X-OriginatorOrg: polito.it
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d731fa8-e05e-4bcd-f243-08db8dfb0f49
X-MS-Exchange-CrossTenant-AuthSource: AS5PR05MB10944.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2023 17:09:23.9132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2a05ac92-2049-4a26-9b34-897763efc8e2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V3rmfdDZZU3hQ2KLSApz0iNoQg3wEVODEKroO18Zm6ViHaRP1fQdH9QL/TB9MGHNr3VBHW+qrAwzGYapy5oWzjeg/iAMVuiCAhqvXQIoEMU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR05MB7291
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi everyone,
is it possible to pre-populate the TDP table (EPT in my case) when 
configuring the VM environment, so that there won't be a page fault / VM 
exit every time the guest tries to access a RAM page for the first time?
At the moment I see a lot of page faults when the VM boots, is it 
possible to prevent them to reduce boot time?
(I'm using QEMU to run my VMs.)

Best regards,
Federico Parola
