Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54EA677CFA2
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 17:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238335AbjHOPwt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 11:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238386AbjHOPwi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 11:52:38 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 231DE172A;
        Tue, 15 Aug 2023 08:52:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fR7i5m1ISBQqO9JZWlueYWUp6/XGdXwwV24fp0LeN8dPLoHHcYCVS+ROVt16ThXGg4T2PDE6Xi+WY1SJgJxx+9M0IC2JMPKIkeagKqxg+BtaM9M0ZyWWxXHoizT2rwpr4NvIqU6gHRuk9aLwqw4SaA4PXWMCuU6M1aQdMY0a1btdd79HQRB/BVD5AC8DPHJc4muQ761wNHFm89i7DQZjxggNgjtWaIjOLF2GVpKCP9nUZnhDjqfWrKj+ZSTKuCt2vKdkBTJQwLAljT4aT4dWd9hbMD8ysVrc4ddlQkK86mMT6JsMjHAKEk55xdZzEXC0oQdDCCbfm+0T0B3x/uS7TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hN7gKrrLJHZ7dt5bau7Xx3RqjqgJh6995C/6VBdPAOU=;
 b=QvUa4ID8nrBZsdAGvlwl3zsv14DiJ7tRJi9tsYWCNKYZErbq8khEhGeScrIi1n2rmMugiJEIsCmd1Z0/gAcSfgu5QKcBHFO7R4etLSqCdv67zI3OB8nT99BLj4c1MgBABOEJmVp3h29GHEi9egPrEYO5uJPyc51BVE00raQE55PpQTJJIw20eIFlEPDXE+68MeMq8f1n2ZuCFaWxC8nL2DP9sQXYX+QPSqpsZ3c3VdGmdLqoXCU9Bp8WCmwjEYgIa2R+H2+PXuZWtPd/iq7v+DOExidl2ExRGRMhftsGcUBxXGZIPw5ZzRpAQ/dguDkbdgXnSFlbsALzIYn4TAKALQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hN7gKrrLJHZ7dt5bau7Xx3RqjqgJh6995C/6VBdPAOU=;
 b=rPV0EhukNJvIZ/tkSTzRsGeOUlVTt64RTPNIeUaBJL4L4EausUPb/Gb6FyOumIsnZ3bBqXHElBskptGwyEoVOGsVRytriwagd3fXfCFOvIpjDo6nt6QW2bYzbpwhRFGxG86ikU1Orq2GirCZynHyI/zWf7stFuibNR+T4Sr923w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by SA1PR12MB5616.namprd12.prod.outlook.com (2603:10b6:806:22a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.30; Tue, 15 Aug
 2023 15:52:31 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6678.025; Tue, 15 Aug 2023
 15:52:31 +0000
Message-ID: <762e3471-834c-ad7f-337e-292394e6dc19@amd.com>
Date:   Tue, 15 Aug 2023 10:52:28 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 3/3] KVM: SEV: remove ghcb variable declarations
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pgonda@google.com, seanjc@google.com, theflow@google.com,
        vkuznets@redhat.com
References: <20230804173355.51753-1-pbonzini@redhat.com>
 <20230804173355.51753-4-pbonzini@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230804173355.51753-4-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0167.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c3::15) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|SA1PR12MB5616:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a7321bd-2680-423f-f18b-08db9da7a223
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y9q4JsPuWSIT9/CrVMtGmX2OuJtrNWXITjhEpPpN1D7nTz6DqNPi8L/0/ijLYbbRZfdHdva4lAqEQnKF0blGzkwIBNQgRu79p+xdVawIy1BnVM8JYW+ojRzZ23ALyvuSX5zDSnfDWyuIgT8clIdTgI/ij8lRc6dAZ2VX2yx4ByW/HMqJZ9YyGdKh5B2FVM9bPCtev2OCDk2XaUHcZMAAlWHFmY63SWqM5cBv7gh78t54sSmEBxYQ8cy0mN6n3Mq0TjINsx55gsyAcBOlncLZcClAmkGV5Uh6AE9Foa8QFXRmwMc3E5MOukHrqMS7WtIvx7uZMph+OqywJwP1a6IO/+Al0bPFENiipcxh+IWciGa1p+q870BldFEx1TYHCyxNZFnikU4BNMK7TsdU4eLMV6DWjdo4oPOR4Pz5TLMhxzZCaQuLVeU9NVylKl+QHNBN2SCaDatm9R6Q0n7+OhdbsSC4Bab6kOf0Q8wE7JoKYxvf16/1UeFnTlnElnpNuNU4iPGMw026XU9ZRK+Hg4nVh4rP8oBTWKpny11yv7vq8n40XUA7HRic5YXa9I7kL6+B2fB4Cr0hg0AfQm+2N1EaWCq9Hn+35Ek/h8kkMEVgw/ajwU3SHgx63LcAqzb78+LGXw4XRNzMM4BAC6aTsa4ayA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(396003)(136003)(39860400002)(366004)(451199024)(1800799009)(186009)(2616005)(38100700002)(2906002)(83380400001)(8676002)(31696002)(6506007)(31686004)(86362001)(26005)(5660300002)(4744005)(66556008)(6512007)(66946007)(316002)(66476007)(6486002)(478600001)(53546011)(8936002)(6666004)(41300700001)(4326008)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ck9abnZkRzBsdUxBdXpKeWdZcExJMFExSDh2dnhKRThGSlZoZWVnd3U1YjVt?=
 =?utf-8?B?TGlIc1d6YWR1Vnc1bmRkY3c1YSt5QUZ3TUs1TWpBUDVpT3QwMGNDWU9IT29T?=
 =?utf-8?B?Umx5a01Kd0pENEpHYnNGd2xGZjIweHQ4NTU4WXN2d0s4d3ptZERScVZlT3Z1?=
 =?utf-8?B?bGJlVkxUbkRBLzJJY1FDNXhQZUFCZS9PVzdUNnVLOWowY1dBMkxNd0J2TDhT?=
 =?utf-8?B?OE9lSHMvSWlKanBRbitpdVc3WXdsdlduTzh1dGNiK1ZOSUN2S0l5SlhSeUpD?=
 =?utf-8?B?ZHNuTzdWV3VENzlZSE5UYnppdGZwNUhtWnpsUzVhUWxkUWIvckZRSzN0RWgw?=
 =?utf-8?B?NDE0UDFtQXN3VjhvQTJ4bTRaRDM2NTRZbFlpUjVDdVJYcTFmVnFwcU8xYjRV?=
 =?utf-8?B?RUZUNmhkUTdIQWxodFgxMVFST0twZDYxWWJGdVZ0cjVwL0hKZXVvMXlTOGRT?=
 =?utf-8?B?dHZFbUkvVUZHMkJuaVoyVndUY1VObkJ2TXdONlpzalJPazV3STVQNXRQeUd1?=
 =?utf-8?B?UDcwUTI1ZmZYQW1WT2gwbWt4bTU1R1JOL0tzQ1ltNE1SdUh3QjRFYmxoZDQ2?=
 =?utf-8?B?VVFpYzNNbXpxN3ZKSWsyOFY2Q2I3QVRFazdaMVdzRGxRQWFydktacVExanFY?=
 =?utf-8?B?aEJ5NEV1dVZXT25BWllPWnk1RTNJNFNuaWZEc1BPcmhmL0FnajlWSmVsUnhI?=
 =?utf-8?B?MXNlUHhiczhZRTFZbkZzQmhweVF0QXEzK0FQMzRNakQrWkszVHljTDlmNXZm?=
 =?utf-8?B?aVlBNjlRZ0JKanZNUHZxaVlHaUZPdTF4NnRpMVB2bUJtODFrNlFXVUFSNUxo?=
 =?utf-8?B?THBSYVpOcUhsTkM4TGQzRHppV2x3OWh5RE54NHNJZkJoZHovZmpWL0RCdnhx?=
 =?utf-8?B?cVZxNG5XL2xsSXFUYkk1WEQ1SUR5am5TTy93MnpnOU1Kbmw2L0JLS3ViQXU5?=
 =?utf-8?B?MWlPa2kxMGpSWDFkcnBYYk9tZk1tMWpEUXgrZ0E2V1RIcFJvTzJYUnhxcjc5?=
 =?utf-8?B?NGRnSVlWcnhPSnY4OXdlZUxGV29mblFzVFlxbTBJWXpzcWlsMUN2RGJkZXoy?=
 =?utf-8?B?QVFoZkNBUE9Bc3hIUkZFV3c5dm8rek9Yd0wwdVA3RnNQVTVnOE1KeVVDd211?=
 =?utf-8?B?NEJrSDE0dnMzWDNTbERJTGU0azdZZmR2d2FyM0RKcWVsTGNIOEE5WFRhTUUw?=
 =?utf-8?B?OGVaWi9xN3pRNUk3N21NM1B2eGNiekIxWjFwMkZ0TVBEaktsZytYNDJiaEoz?=
 =?utf-8?B?S0xvZkFiSDJieENlQ3FyZDBKdzArWEFkWlI5QVVSaXBRUjhWaUk3NEF2WGUr?=
 =?utf-8?B?RFVWMm1iVERjNEI0QlI2RnN1RzNhS012OHF0b3hQNnE4RTUrcVl6dHIzaGhJ?=
 =?utf-8?B?V0dBVVJqOTR3ZFdoV3d4MXl3azNLY1pPTlM3TmNqeW9XUjQ4bzY1WXphc2Fh?=
 =?utf-8?B?S3RjZ0FQa21FNGVBUFdqbnFwaGVXUU1Lakt4L01vd05mcjFqOGNHLzNjaklZ?=
 =?utf-8?B?VG53djNNanZkZXFGb3NjTEZCb05wMXVneDdqeVl4ZHdNQkFtN2NxSi9GYzV5?=
 =?utf-8?B?OVBYWWpUZ3ZoYllpQTVZbXhYS3c5bFNLcldqQWcxRzlxbmFYaEE0TTZ2ZnFl?=
 =?utf-8?B?R3ZzTng2SElpMjZ6ZHJXd3FKMWhIa3FDNWRybzFKMWhOYlNVUEJjbjNGMWlq?=
 =?utf-8?B?ZDlRdGwzMktLMnhrZTROK0JBdDcvWmxja2x4ZzVSMHBYZ1U5LzlkZXdlM2FM?=
 =?utf-8?B?aHJhWFBKVTNTRVdHOHZsY0Fucng3TU5nNnAvVlMwL2VQZHB0L3pESGNTMlpy?=
 =?utf-8?B?WXUxOFdQeC9Xc1NlSW5RbTIvWHhScWlDQkVtcDZPakNlYWNKQVNEQlU0SWRa?=
 =?utf-8?B?RmcveUZTQzhPUW5PM216cjExTUhkZ0V2azhDekNWUW9rRkpvaG9hSWVET3dM?=
 =?utf-8?B?VzBqVlBFei8yQlRLbzE3dzNGd2x1aW9US1cyblptUUNYSDIyU2N5bUxscHQx?=
 =?utf-8?B?bFlGNk81U0h3WCsyUUhmZkFBaHdhUThTOUhudHRqSTZua0hqQzVYODB4emQz?=
 =?utf-8?B?RTNXMndqMDNLeTBCZk5pNGkzZG9ZUnovQVpIMVN2YVVaMGtZUmZXdCt4RTVO?=
 =?utf-8?Q?V4JRHzNe8x5ilmumzVUFTSXFV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a7321bd-2680-423f-f18b-08db9da7a223
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2023 15:52:31.0642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9imzxgbSTq6oj72F9u4FW21Ds2WCcgE/wbsjwPn4AYWXVIHQcorpWVRevyirLKjwnTHc7TKYj1OTQnUdjf67RA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5616
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/4/23 12:33, Paolo Bonzini wrote:
> To avoid possible time-of-check/time-of-use issues, the GHCB should
> almost never be accessed outside dump_ghcb, sev_es_sync_to_ghcb
> and sev_es_sync_from_ghcb.  The only legitimate uses are to set the
> exitinfo fields and to find the address of the scratch area embedded
> in the ghcb.  Accessing ghcb_usage also goes through svm->sev_es.ghcb
> in sev_es_validate_vmgexit(), but that is because anyway the value is
> not used.
> 
> Removing a shortcut variable that contains the value of svm->sev_es.ghcb
> makes these cases a bit more verbose, but it limits the chance of someone
> reading the ghcb by mistake.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   arch/x86/kvm/svm/sev.c | 30 ++++++++++++------------------
>   1 file changed, 12 insertions(+), 18 deletions(-)
> 
