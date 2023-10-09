Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 828C67BD255
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 05:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345027AbjJIDUj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Oct 2023 23:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232250AbjJIDUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Oct 2023 23:20:37 -0400
Received: from AUS01-SY4-obe.outbound.protection.outlook.com (mail-sy4aus01olkn2162.outbound.protection.outlook.com [40.92.62.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618BAA6;
        Sun,  8 Oct 2023 20:20:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YxK1le7cgBP8DclGA3FYVd7NwvcAjQmQ1PXoFQ4S/H7oKay6CVZN5Vpvvlxj/lwX/YpF7xEPggEPgFbETEuFKPBb43HojwOeetRZwVrY0M1aqWmnZRkwPvm5EZFLietWUzqbrFV+X3GYyb/ym62vn1gaHLO9seYuNUQ+ixNvFKKZxheatUD51o372tz8H72uBkmKMZIlGCXPMee2r+5XP6+QA4Vc6+pAuo5Ey+AK0LoX1mOYYpe9KeUv5UdDX93VLsgKqFMhAKk2LaafJV4pmBDQaXQVWmTRVgODuDwUy9Z8M5YxHNu8q3Z9vgI0zgZJ9v4CQPeVRjijouae6NlUGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bP174MRXsKg75uCVcUBGkPpb9klkKIrMdFUTLbBM4L8=;
 b=WLLqT4eenT8Yt44K9GgyjlWEWJVOkCvPXglhKznqGnWuT8fwhDTUQ57T/5PHI68uYYxNo0hPgg6p4BadsixqXIneIpfpsXv78NadW+iCi+YsFzcwCdn18l3ZOwve97RAUDpv1Lh9VS+n7q0a9uSxFG0imJW2trGyqnBRhOW3aBWeW3bTHHIWZe7Ue+GP8djU6sHIFn5Hv8oAB7FkIl4ygEci4C4N9PcgBt9N+2Y5G3UnA0DRA+8P0hlpO3wQD0gPuBjdNTGoKjhrF6P8dKmYFe70/UpgFn4moAOBRxZ1FdFWn5pmLVYhvtT3eGgRscZbz2rJ14ZLIZS9hkHY2tRj4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bP174MRXsKg75uCVcUBGkPpb9klkKIrMdFUTLbBM4L8=;
 b=OK1uwD50vcpH2qvyyHwBwBHC83rz4e1NOKFLsVrOP4wTrZ4CTC+9xBbw3Lymo3Z4QtgNmY01qpcj5oVzoo6QY9kFfVPrTjo+K2jqXgjeUFeXT3fcpPnpmEDvIECZd9uvJyi1oLyeR+h0PZKft3+USjuAgdMK1VJObmIbNACnue22Li2fXRZSn21et4FDH7aHo8hERUSlMT/XJBqEg/xHV2oMaFsckctIe2EFkh/OD0kZXltGufE80mMVMYdlG0L4ebHj7p9wBTzwJ2dpU0WIaGG8aCm/UgAYBY8DvuJpwOlIp9ysJZxxoOLsYuc8cHySXjqohC7ip2XxokAD+og8og==
Received: from SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:ac::13) by
 SYZP282MB3332.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:16d::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.43; Mon, 9 Oct 2023 03:20:29 +0000
Received: from SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
 ([fe80::e39e:17fc:36d8:1ea8]) by SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
 ([fe80::e39e:17fc:36d8:1ea8%3]) with mapi id 15.20.6838.040; Mon, 9 Oct 2023
 03:20:29 +0000
From:   Tianyi Liu <i.pear@outlook.com>
To:     i.pear@outlook.com
Cc:     acme@kernel.org, adrian.hunter@intel.com,
        alexander.shishkin@linux.intel.com, irogers@google.com,
        jolsa@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, mark.rutland@arm.com,
        mingo@redhat.com, namhyung@kernel.org, pbonzini@redhat.com,
        peterz@infradead.org, seanjc@google.com, x86@kernel.org
Subject: Re: [PATCH v2 1/5] KVM: Add arch specific interfaces for sampling guest callchains
Date:   Mon,  9 Oct 2023 11:17:51 +0800
Message-ID: <SY4P282MB1084FD036E733BBBE4D476FF9DCEA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <SY4P282MB10840154D4F09917D6528BC69DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
References: <SY4P282MB10840154D4F09917D6528BC69DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [fZ6jKpMVpMREBgPTFIRAkP8nV6804dbjmsKjbX/fT2pASNeEM7lkDQ==]
X-ClientProxiedBy: SG2PR04CA0155.apcprd04.prod.outlook.com (2603:1096:4::17)
 To SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:ac::13)
X-Microsoft-Original-Message-ID: <20231009031751.15378-1-i.pear@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SY4P282MB1084:EE_|SYZP282MB3332:EE_
X-MS-Office365-Filtering-Correlation-Id: 61188962-8834-4754-09c2-08dbc876af6b
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yRRkY5fZ0TK9tsijbxuha8+MdE1FGYHZoK4OWDO2uxLAQi6FGnMVkE488bLSOgkD2Sh+zkmzPmuNHxVMqGSWtChJvvi3U/R2ui1+WHIq1pYKxfGcQNnXA9blGK0mkkjA5VSvUXRf1wU2ZhYn/dSbygWwj6YoDVa6QIrELmrADH+Tied/9NzotbnOmQP2VMBREqGBF8Ei+7+wxfhdfOKLTsebGuUNXugA3hKKSTv54agec4Qud6G4MFIcQFceUFi/D9JdT2/YWOpHDbLgNOyf9kyc3TrGGP80DLlHnBF5uFSykHQ+vcrrq3VwC9tg1e/fpGqn39vVw/zBMwPYuOh+CLMDaLEiwSZ/iFfAiSu4tmM+ICYWINXKdBypmUa7tGumGWye5qgbA8Y0RQRdRIaO9rn99TVXIKzHJYsc999YBzZsc71lno5Jn2C2cWDE8OrJ2J5z5GRUTSlUlW/jrMqLB9zsZotiU3xLlQFDNos6ZWMF5XaY580S7ajkG+7dtwiD3oo21YED8PoqcClo8qjoG6xAaAQgWmNFKhN5g+CKE0immFF8M6i8awZl06UDd7tvyJ3q3c9GzlwvTCNBXE6C1+Wr4qNyVdco859bsTTcxV4=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZSJNkYO58PcKPWcUlqFU80uRG9NLIYVoEz5Q9DJUo60FMx7t8akE0aN35xdr?=
 =?us-ascii?Q?JLH/LbrKcUs6sVFLRsJQgJzIf3EkWqK46tOHxZE0SFjomJ0jdmyvCGYOJbZy?=
 =?us-ascii?Q?BvlHvM+rsGFS73O921dknJribiz1Zax0fon9XkRKR9bTG+j2WJQHjQMPOX16?=
 =?us-ascii?Q?NVR+ns4jp0iiotH2hahdHe8C6IA7BTx1s/JLPP0Ncn2ku/NuYtkiw3SEzeN7?=
 =?us-ascii?Q?0/Vynu601MI5tyMlQSixpplT7LbuUXzc5pTsUWOiZTsUX5Dn/dZ+2jNuXxiz?=
 =?us-ascii?Q?OAmQsUpxcArkHf0lfe+dNuSg6jFJSYlX/R/1u2bVbuD+hPfUECfL3KfwAmX7?=
 =?us-ascii?Q?nRITXQd7/v2SKbRs3be69YnQ+kW4uCshc6QHtaYPanCFl7K3HiS1ZTeruEIJ?=
 =?us-ascii?Q?/DCO92+giGOqnt1z1SHd2ZFPNrfqOPQ17iMcpsmC4eyF7Nb0gZXAXxF/nj78?=
 =?us-ascii?Q?SWKaG/KOOTW3yJbny5ClcKVXTxecetqEJ+2+N563m0CY/M6y6Hd0M/VyeYj4?=
 =?us-ascii?Q?okNae/hQCdCH7Ri5y50tGkq/3QuC9lCwoj4TwUOxpqjrl/Wq+WaO9afDuGDB?=
 =?us-ascii?Q?oEXZWFr7hIyY8+8tE9URfy3Wzs/FASYTeoJuB1iOrccBuwjfIkADbRV7xdOB?=
 =?us-ascii?Q?4rqDiuRxrTH6T7RtY6mYqzLWeN9j0RV8JqG2WQUR9o+k5AYo2UDABz0j4KNW?=
 =?us-ascii?Q?1zt+ZBHbID/UAa5Pj6uSwYR7ls/luaMWqhq7r2tap6xyxsP96uqBjpqaZwiZ?=
 =?us-ascii?Q?5So3zFJn+GQM3kDf7Zdg00l3eMiiTLmUOrPz8hKglWBAcyjDdSkeMZ9lFMN0?=
 =?us-ascii?Q?bfzLpfVFY18+qmum9iBuwkychPwXLW9zoqbSXz5nYs+hr4yzRY11GTYrhkyv?=
 =?us-ascii?Q?gATF76Bz4JTkApcyTQo93u/CE0bwEeGEw51UcZPoIz0IECR00W33fAqxJYTs?=
 =?us-ascii?Q?mtxq7msyJkoCcQcUzv4P0JBYh9GkAZpSQ4Vm/DWmRRnK6MHKvnDC40dD3iRS?=
 =?us-ascii?Q?ZP/zHKo3mz6wdwQO+FwgmKBPW9mReBXGE51yMpO2kEpbeL5sdp5KgGQy1N2W?=
 =?us-ascii?Q?O0a7vRD8Sh3flkcErVsLsGytZG4rLYN41TzVxhzg3Qn6eU7eOguz9G7y63H4?=
 =?us-ascii?Q?dF8Io80kYaiqsaEaeoum61SrXOXtT56KMH1Mu62XGubunER18yJyMkh7wBun?=
 =?us-ascii?Q?g2ZRsvUcCyHtgHxO0HlJ3iLeEXVZflHiGJGG9O2ZlQnA2VAcbnsx64dIL+FO?=
 =?us-ascii?Q?M/Om2+9DyYuTDD0SIzg9?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61188962-8834-4754-09c2-08dbc876af6b
X-MS-Exchange-CrossTenant-AuthSource: SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2023 03:20:29.1280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SYZP282MB3332
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> All warnings (new ones prefixed by >>):
> 
>    arch/x86/kvm/x86.c: In function 'kvm_arch_vcpu_read_virt':
> >> arch/x86/kvm/x86.c:12917:42: warning: passing argument 2 of 'kvm_read_guest_virt' makes integer from pointer without a cast [-Wint-conversion]
>    12917 |         return kvm_read_guest_virt(vcpu, addr, dest, length, &e) == X86EMUL_CONTINUE;
>          |                                          ^~~~
>          |                                          |
>          |                                          void *
>    arch/x86/kvm/x86.c:7388:38: note: expected 'gva_t' {aka 'long unsigned int'} but argument is of type 'void *'
>     7388 |                                gva_t addr, void *val, unsigned int bytes,
>          |                                ~~~~~~^~~~
> 

Terribly sorry for the build warnings, which is caused by type casting.
Will be fixed in the next version.
