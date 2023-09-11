Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 663F079BF0A
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbjIKUtY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242658AbjIKQEI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 12:04:08 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2074.outbound.protection.outlook.com [40.107.102.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3AA01AE
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 09:04:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZhxU+0wISTRM8T+/zHr8ffc3cJ9Prt/EIHmwNmksxspQBJfEHuPNLGQ9pVwAOkznsQ0EB/ysVKJP6MJ8wo9ASno+gosKvmaEneeaJnsjo+b/XzcrQ1cMflyjOwWVLvH+q+PatHZcmoIJ1IFZjSkRG7CFxM4uEKGGbnhoBW62YCj4EBGj+Vi4sLfgE7rHTkDuQ7MOugc6l8zrVITjwyRgl9ssuf4ta45JYBpPTPX9ZaXamkZGUbvW311bOvFneVxs+sNmpAs7Rjh/zEofkyvBe9wdUC3nhbYtfao6uCiSHuqQjOxnFXuPXdIH3ZRjEDTAhLrlbu3Q6131cnztK6HMqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xv6tHUcRu8aiCx3yhdMW+d19mNHHxa5qwpPH8VQj4tE=;
 b=mei5nQe9Q2mkMggvaSqladV7luOB6hDnv/omrci0VPPU+iJFK9mEuqw8VyaiL9exLnzUjQd/eETRbMFsRNBoe65obUsWxb3dNLOFTOKjvvO1863BX/oBCSsujpSTtGoZ4LZB6aNEA7KnfxXI176XLxunKoFhgWA0UgAgbh1GVFXcmegG2O6vMDI8nL0AGaFm/xncGLFfBCIudNoJnnMtqVAOxQUGxaH+dE2SB1K+S8wEEXk3Ikk+X+pHP7VB8TRuJVguKNMiDmgksN18yg/syvImHwXqvhQEdu7VyKVVo0C4cyGk5i6Hg9ibdk4gh5UIRsssD1zqSaYHyBoM55z90Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xv6tHUcRu8aiCx3yhdMW+d19mNHHxa5qwpPH8VQj4tE=;
 b=zZ1xeXyqzWapk4SswybogsQwb6eaGQItqw3PCDBTFzXS4e6Mqo8fgatgmzN538sFeQDrr9DwMo9Tt573PMyDH8CMVQU3YlqvE63OK013B3iD8I8Sr6hpPhSpJTDcFU6+OLxHR8bGoVVsRxIJvjZE0dJJpDgzMXBXnGvPGoYDigA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by DM4PR12MB5069.namprd12.prod.outlook.com (2603:10b6:5:388::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.35; Mon, 11 Sep
 2023 16:04:00 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2%5]) with mapi id 15.20.6768.029; Mon, 11 Sep 2023
 16:04:00 +0000
Message-ID: <1a52e623-9270-1c2e-7c21-2be5b94e433b@amd.com>
Date:   Mon, 11 Sep 2023 09:03:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [bug report] vfio/pds: Add VFIO live migration support
To:     Dan Carpenter <dan.carpenter@linaro.org>, brett.creeley@amd.com
Cc:     kvm@vger.kernel.org
References: <1f9bc27b-3de9-4891-9687-ba2820c1b390@moroto.mountain>
Content-Language: en-US
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <1f9bc27b-3de9-4891-9687-ba2820c1b390@moroto.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7PR10CA0010.namprd10.prod.outlook.com
 (2603:10b6:510:23d::19) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|DM4PR12MB5069:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b521d6d-2615-4adb-a7a2-08dbb2e0b5f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R16xBm+OtPRmUNwccRxFEPWvDAXgYPugzt61xPQUaswDHKnw8TFZi1znb9Gss1RqEYNOUdvb/tr+MaQMolLDWeqekLRjrCa5WTA08Xu+u79sju2l48U/ivRmOdcUSQtRFQkkU/zM33WP+NDoog+QzSMezHNN1ljYpG1y4f25WO63JA32y45i2Tz1eEWsLSpWQQUV6js5jniv8EEiwScywbNnp1iQvm+6JZZuC9km1nx49gmYhrTrwVmhmKIyrFAODgPPZlR8GIOlyuQi7xMwnmg5opeTJMczQro16ZxCZeuMpOmt5kVnNvSwfWvjdO77/90OWsGAJ+nb7QNfjJNM+oWb4Xag7sOPquEzoRtwbSIRSlMkSWnUm8DKiHIvERFwv+8GHVAlPV4VAxB5LNdG9EoD/4L5D9TypbAc1v1Rdfp7uBicUWHSnWgHlNhWs13Wcv04p1ct2zBgLFRmVlPnl9/G9fYgaICdNlnbM78in7FFMP8NA4tz2nckXE8XUqpwpOohTwJZh8JK+JEzUOVF33kLyopJ+j1ORqJrN8+E1vgANbxUrp4Gp9Juji2/BZLc2xCD6c4KfWsmqBhtR72CToTtcocgj1e3neJ2BrtqSNew7t6aR5y+VVX60YzUHpyGfXdRpk52FhTGo9xdUKqs7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(39860400002)(376002)(136003)(366004)(1800799009)(186009)(451199024)(36756003)(31686004)(2906002)(38100700002)(31696002)(5660300002)(8936002)(8676002)(83380400001)(4326008)(2616005)(26005)(6666004)(53546011)(6512007)(6506007)(6486002)(41300700001)(478600001)(66946007)(966005)(66476007)(66556008)(316002)(6636002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OWExUnRsK2tKbkRoOTlOYVQyOXJVSnZ5V3h0RStBVVhPbklHME9XVURjSXNE?=
 =?utf-8?B?OTBUYXR3b1JXKzhDNFhFVXdVT0d5emVxamZ6c1JkaDVpTE1qbkVqZ2sxUUpS?=
 =?utf-8?B?R1ZsbG13WGc3c3hRWEpYcVJrMlR2SWRucVRQVzdNZS9Vbzkvam51VElkbnZn?=
 =?utf-8?B?dDJaZGRJaGErOFcxYmhaOHczRjRxcVpzNnpjVjNOemFWUmNVT1E5U29UY1Yz?=
 =?utf-8?B?d1BzVjF1amNTc0MvR29pQ0VZWnphT0lBWTc0S2Z0NnZEY2w0dVIrQ0RVVEJV?=
 =?utf-8?B?WEdoVEdDWnltMGRaRDdUdlF2NFFZWUJIVmQybmhRZElibDhrbi8zem91ZzFp?=
 =?utf-8?B?TDlmTWdTd2tkUTVWN1FVeklsa2k4L1NtT3hlUTZPSzBPeGhFNXIzR3J0RElr?=
 =?utf-8?B?cHJLZmRQTStJblhUSHZBanBiVWtwOUxPcVUvR2RHTVYyYlJTWksxck95Rk1p?=
 =?utf-8?B?cWFOZFhURisvdlN4Wkp1TE1qbVNVRjNjWU1pWlJRZEFYM1RFTE5RakhLU3lS?=
 =?utf-8?B?b2VCU3owZ2xURnVYTThXdlRXWVpIVkJqalg0WTk5aUlQcnVWT3I1YmduQXc0?=
 =?utf-8?B?ajRpNFhUZ1lEUWsvMXY2dks3aWdnYy9DeWtHZDRBMkFLTnVhUTl1bVFjanJs?=
 =?utf-8?B?aU81R1Bha1djeU11cmhJTDRzY05SRDBuSkdxcnN2a3dWdE14b2JFWGJYUnZt?=
 =?utf-8?B?UTJaWFpXbHY2UGc3NlFXM2NscFQzT0VVcTV1c1praVZhc1h4ZHljaklhLzZa?=
 =?utf-8?B?cnhBVUVlRk5wNFA2aklvci9kbzZ2YTljcURBb3VzSWVmYnRNbVVHeDZwdW9Z?=
 =?utf-8?B?RFZmRDlIYlRDMTlHam5wUFVNTzhoSmpaOFdFRkRoRjlkVmNsOVlMemk2SHNq?=
 =?utf-8?B?ejJHUGI4MExSY01sVjYxdEJWckx1U0dRNndIVi81ZXFydm9vdkFFMlFCNEVU?=
 =?utf-8?B?cUdGUzZLaUhnb1lzeUN5UzlaM2lqRVZDM1d0WDlkZ0dVVkc4TGtKdHVXdzFn?=
 =?utf-8?B?NGNmZ0E2U2Ric1F0ejZBbk05em5QT0I3aGZzTXlVV3BFU2RHenZOUE9vdDNy?=
 =?utf-8?B?bkJ0Z1J4andCempTYkhYWHMrL1l4VXpKR3M4RExIalBUUkJPeTJGWHQ0OTd5?=
 =?utf-8?B?eUtjZklQOEcvZEE3L1Z3WEJrZi9ETWtWM0UyemVONEQyWE4vT2daOS9PZEhz?=
 =?utf-8?B?ODA1T0RHY2J3d0NTYUdBZGVTTXZndFRpTEJGcWhjaG9CWXBGeWVYSERrTTBC?=
 =?utf-8?B?bkVvNjVEMmt0TnVCbnk4ZExOOXFpTmgzSEZML2w4azRBYUd0a2NIb00wbVRo?=
 =?utf-8?B?R1dIcXlKWnZsL1BDN1JqT1pnWkpXeHoybitUZFQ2bGVDRy9ZSzVYYWRnUW85?=
 =?utf-8?B?WC85c0QrRU5lZ1JESFFJMi9DRHU1R2FBajdTaGs1N0FTclY3YlhYbWtzNkc0?=
 =?utf-8?B?Wm9OWmhEWmE0T2VGNGVubFNNeWxFRFFtNEF5ZlpDekR6TWhyVEw4NE8ySDdD?=
 =?utf-8?B?WDRLTmJ4R1B6WHdkWW91RWdyY3JLMVNWUjVXaElIQ3RveW9WTWc0MjZqaDZh?=
 =?utf-8?B?cDJYNnpTSktRbnhqL0xvWXRwVHdYZ0Y5a3IxU2xnR0docFcxWEdwNnBHbmpy?=
 =?utf-8?B?c2dHYWZaNnpreHlHZXhFeEUzUkUxSnR4N0dianpKUXpHSENoSTFpTSswU0tN?=
 =?utf-8?B?K0FObXhoYXNQTmVNQnZjTW5hUGFkL3NBNDlxS24ydXVvS1A3c1lFMmI1ZjlS?=
 =?utf-8?B?Z3ZjSzlZb1JqVHBBQjRlY3o4OThza04rOUxQV0RIR0dpckFXQ0JGQ2x5Znls?=
 =?utf-8?B?d1V2dTlSeTcralpYWm5DVEMvdStpSW9rVk1wVHBHSk4wbFBKc2lHUXB6NjdO?=
 =?utf-8?B?TU5rMHJ0OEIzektyY0hiK1MzMGZhRWkydDAzMXdka282KzdoaTBHSkFYam8w?=
 =?utf-8?B?bnEvSmRycEV3cjI3cXdPcnpFQkJ5NVRsazMyc0h3c20vWmRNdkJBQTZpZ1VY?=
 =?utf-8?B?aW14dEVkWW5BVjNTMUdiVHlKQ2kzWkFja1VpZkhsdjBENStRdE1KSDdPajRw?=
 =?utf-8?B?WnVLR1RXZVQ1bU9uVTJ2S2NzTldTc0FNMzlsVVUrY2ZkaUZxZW5hR1N4MXY3?=
 =?utf-8?Q?OCasG5OJY/cC/yox8wHY19fh/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b521d6d-2615-4adb-a7a2-08dbb2e0b5f8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2023 16:03:59.9816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GkQ+siZwCqZx/FYwwDkdvWG7hFgcHYyhxmnN5gAPlogw+RQcKlBLAtJD+DbbuvI50KtPbK5w2LNu5LfElceonQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5069
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/11/2023 7:24 AM, Dan Carpenter wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> Hello Brett Creeley,
> 
> The patch bb500dbe2ac6: "vfio/pds: Add VFIO live migration support"
> from Aug 7, 2023 (linux-next), leads to the following Smatch static
> checker warning:
> 
>          drivers/vfio/pci/pds/lm.c:117 pds_vfio_put_save_file()
>          warn: sleeping in atomic context
> 
> The call tree is:
> 
> pds_vfio_state_mutex_unlock() <- disables preempt
> -> pds_vfio_put_save_file() <- sleeps
> 
> drivers/vfio/pci/pds/vfio_dev.c
>      29  void pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device *pds_vfio)
>      30  {
>      31  again:
>      32          spin_lock(&pds_vfio->reset_lock);
>                  ^^^^^^^^^
> Preempt disabled
> 
>      33          if (pds_vfio->deferred_reset) {
>      34                  pds_vfio->deferred_reset = false;
>      35                  if (pds_vfio->state == VFIO_DEVICE_STATE_ERROR) {
>      36                          pds_vfio_put_restore_file(pds_vfio);
>      37                          pds_vfio_put_save_file(pds_vfio);
>                                  ^^^^^^^^^^^^^^^^^^^^^^
> 
>      38                          pds_vfio_dirty_disable(pds_vfio, false);
>      39                  }
>      40                  pds_vfio->state = pds_vfio->deferred_reset_state;
>      41                  pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
>      42                  spin_unlock(&pds_vfio->reset_lock);
>      43                  goto again;
>      44          }
>      45          mutex_unlock(&pds_vfio->state_mutex);
>      46          spin_unlock(&pds_vfio->reset_lock);
> 
> Unrelated but it really makes me itch that we drop the mutex before the
> spinlock.

This was done based on Mellanox's implementation and there's some 
history/notes on where this came from.

AFAIK these are the relevant pointers for the original discussion and a 
code comment as well:

Original thread: 
https://lore.kernel.org/netdev/20211019105838.227569-8-yishaih@nvidia.com/T/

Also, there is a comment in drivers/vfio/pci/mlx5/main.c inside of 
mlx5vf_pci_aer_reset_done().

Maybe it would be best to add a comment in pds_vfio_reset() as well?

Thanks,

Brett


> 
>      47  }
> 
> drivers/vfio/pci/pds/lm.c
>      112 void pds_vfio_put_save_file(struct pds_vfio_pci_device *pds_vfio)
>      113 {
>      114         if (!pds_vfio->save_file)
>      115                 return;
>      116
> --> 117         pds_vfio_put_lm_file(pds_vfio->save_file);
>                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Calls mutex_lock().
> 
>      118         pds_vfio->save_file = NULL;
>      119 }
> 
> regards,
> dan carpenter

Thanks for catching this. It looks like this is due to a misplaced 
spin_unlock in pds_vfio_state_mutex_unlock(). I need to make sure to 
call spin_unlock() before calling the functions that are allowed to 
sleep. This should be fine as these functions are already protected by 
the state mutex whenever they can be called.

Thanks,

Brett
