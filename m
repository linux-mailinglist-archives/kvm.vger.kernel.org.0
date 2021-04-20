Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEFC36600C
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 21:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbhDTTK0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 15:10:26 -0400
Received: from mail-eopbgr770082.outbound.protection.outlook.com ([40.107.77.82]:39030
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233617AbhDTTK0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 15:10:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KTdSRhsQ3y56tq2Vlpy0VPzoTAplAo3rrxzYCxT48vfTPEeoumm1iBRsPeNcxqAOPVR6gzq783Yw/OH5dxsZY7qq9RokhDA8j6RFgTdV5LIE3mlGVBzWxOZTq1LvR2XW/gDiBsKhKAPxWJkPi6x1fvokEcO4QOKLh1JGSX+sjpMg/sGrsHAf0mPhscuFJGUoTsw66hoAccE63LtQfcXPNXV6GBllTsuLo141Xb/BkxZ8/lrPGoQ469gzqSiGUJBW2Dz3rVvqrqzqafXlVexxtygSjwMHfi2es8FQG28d2uPwcgQsxqY8HChSyJlFpFcTul78bEYflHKn2/ReypRUMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fpG3MUKXqXaL3zc8s80OZRYA7oLQhdPQa+1VPeu4fc0=;
 b=YjcNEj375Ogj9cGVpQCYSxYKYb+yQJ9E4vkKpcsIOQCtQTDw/GMopPfQrsmYlXncssreBEC67ZH/AFLe4PEPb6aRtGJ/YPzin5/D5NgAgirGQcs/OaWONjcba686U4CSKamo151x1h/UYNs6Xv/quze/CwcsYv6N5AsGtfGOoRkQvA8yd89bdzD/tp3tcoQU1kwPN65aUK/MOE1icXoMuNylSvq69mHoP/WZtMPT2C3U2MjIf5h/gAR5mqgEtjOkBw7TTsC9TbWsutg1o55DUzRn0AN6wI/uLZ8maN6WlXEQYI+0DT6lNG6a3jQsCY2y+dRUxaTSaDWZaA1OXqLcuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fpG3MUKXqXaL3zc8s80OZRYA7oLQhdPQa+1VPeu4fc0=;
 b=hunP1Akz+LfMBOJjna1oPibFAT6aq87cl5bFWBy7VyYUittY+ry3AIPVLmz230+4ZzTIHdPJtAbVvpusST5j2c7F5L4pyhSIVBHyzAq6Vp6anBv/fXxkrmmD77gzBmvWbwtn7zS/M165MbW3zOiy5IftTFG3YPFpnxJ9VJoYVpI=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4573.namprd12.prod.outlook.com (2603:10b6:806:9c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Tue, 20 Apr
 2021 19:09:53 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 19:09:53 +0000
Cc:     brijesh.singh@amd.com
Subject: Re: [PATCH] KVM: x86: document behavior of measurement ioctls with
 len==0
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210420093411.1498840-1-pbonzini@redhat.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <d239645e-cf7b-a235-85b7-a7c2afc08dea@amd.com>
Date:   Tue, 20 Apr 2021 14:09:51 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210420093411.1498840-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SA9PR13CA0164.namprd13.prod.outlook.com
 (2603:10b6:806:28::19) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SA9PR13CA0164.namprd13.prod.outlook.com (2603:10b6:806:28::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.6 via Frontend Transport; Tue, 20 Apr 2021 19:09:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5bbb93a5-f99c-4161-fbe0-08d9042fe0e3
X-MS-TrafficTypeDiagnostic: SA0PR12MB4573:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4573F188D8D8C66A5A8DE6A4E5489@SA0PR12MB4573.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p5p10BQypVvlU2yyB15I2J0xX5EZHuoSunyXGVyT6/a0408wqtmfC7FBHUkNnI27/JvwLaBvWNuc/09sP42bcTSjfyXm6BZOb9+AtJLAnC0jwBCZoZUKs2ATb6VuZzUA9r7OFSbegmHG6AmwTNgxxv3XNQSJcZMs5F6amrHeypemPG+KIkrMGGDRVuOjl8mWRd83Jn+j8aK1py9X4eRrJkeqogVY/IDgR7OR+oWdtIADBG+5RQ6jayYYqCMHnQ9S6KUGpRFCClSbt5LmcS3urt+0OCWxIdB81rPX5gv2UQKSl/fH1CBa1CEtpSfOKWMF4vD4Z+L6uoeiXm+8tBQeN1lwGtPPqDsrnHiJB6QQ8OuHyZQzA90juSn+TlNEkIRDxM7BoZC+5v0sPIAJcOrEIvyAUV3/8oCXarolsog/+bHieXGofuEIHwnoWtIXeNJ/OUf2taCzE39SjXCHcCs3sBTF+deSwKj6sBHn5zv/h2SHWrDPcPt/2XY/Hrivhv3jEx0X1+aR5Q8WWxG+fB5fdiZEn8KLz95R1w/klDRaWxy9JvToCmUwdxqvXACuUlBV1QeJKfrDfpkSHXG/qRKSnnPPZqo7UHHb+S374WEZnApaaMHS1sSU4fTDQnjGOdHt1AYxQ0QEBGqbrQ19WcopS/prM9NntU4eJIMr/TJVkmkYHHH+TucLb6+jPxn29WCsYitZUoGwp/I+YI4TFC2Zcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(366004)(396003)(346002)(8676002)(956004)(38350700002)(36756003)(2616005)(53546011)(6506007)(6512007)(31696002)(26005)(478600001)(31686004)(4326008)(44832011)(86362001)(2906002)(186003)(8936002)(66476007)(38100700002)(6486002)(16526019)(5660300002)(52116002)(66946007)(83380400001)(66556008)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TldiK0tIdW5QUEZkbFB3ZEVCMmNsemdNU2M5L1lUQmhNdzN6L1FHYjdIeHkz?=
 =?utf-8?B?dU9lamUrdmdKWndlUFdYS3BKMkNxQ1ZVcS9qcG02U3FZUTVROEhZd2VhL2VX?=
 =?utf-8?B?cUtTcCt5SWNwU010eG1DRmZRUy9ObTMrVU5iWDNIdjBCTEorUEROc3dBSm50?=
 =?utf-8?B?bG91QXdveW9VYnBzbWhIdDZGQ0ZTeVhOdXYzM2dxaTdTWjJJWEp0d3BGVEpK?=
 =?utf-8?B?clZ2WlhFdXI4NElnZ2xLRmI3VWg5WlNkUDhhRHhlaTNjWHVZUGsxYUo4MDI5?=
 =?utf-8?B?ZGJIV3gveDFJRFVtOWJWOTRRMG5YWk1VOW9aQnRpM2FxOVR5c281Y0xrRGMw?=
 =?utf-8?B?ZUZxM0RzbWtaVCtKajhiTFdzRkovWXlEVC9xWDllckJiNjVyVnQ4OEtkangv?=
 =?utf-8?B?d2YydlZ1OE5UTTZjVUNTUjc3S0xEWDk5Y21PTGFYSDFkVFY0bmtPaDZrRXN3?=
 =?utf-8?B?bVowMStaVlloejZJbE45ODl3Slk5aW5sQ1k3dGlWcU9GZkhTNUhiRlBENjRz?=
 =?utf-8?B?RVljVWRqeC83Y1c1eWM0T0lvWGhsdTFTbG1QbUZOMXdXVE9nNzFRRk8vWFhP?=
 =?utf-8?B?OU9XQkNMWmJ1bkREMzBWSEp6NllzM0xpQTl1cUg0ZTh0ZWdPdy9naWZxdUVl?=
 =?utf-8?B?emQ5RkhrcjlsMXVVeDBUd3BRa3NnTHZodENHSVVhcUcrU01aU2NoZXl5MVY3?=
 =?utf-8?B?MUVzR3JrdksySzQ0VWNLY296OWlHZDJaUlp6aVZ5dVBhaGk5MVdzQTBZTVVZ?=
 =?utf-8?B?a1RNc1dJZHN6Qk1JNy9jVnFVc0hMODA1aVdpRDQ2dVFDS21HWVNoWFJ5bmIw?=
 =?utf-8?B?Y1Jab0lVdDhmR1k3WFR4RGhKS3Jyd2EzcmczTnNVcHJSWWZaeVVvZFZDeGVP?=
 =?utf-8?B?MmUzQ1ltR2RQNjJKbTFZaDZ3U3lGVGJwbWR3RXVqTXU5NmhDem5DRFBKdHo3?=
 =?utf-8?B?eXc1ZUtLeVh1UGdYeHF2U1doZUlHNmtsRnVaeUMzbGkycVk1bmYySDczdHBh?=
 =?utf-8?B?djNPL0dPNFR4RTZTOFJRdDZiSVAwNldrd0hUUVFlSzlWNU81dXZzN09VY203?=
 =?utf-8?B?QlhieU1CeGJDOGI5eUFTQkUrN3A3T3RKZHV0OE1HdU43ZUJZUk1pRlVubndt?=
 =?utf-8?B?UnFweWNPMGZKWWJXZ1NvNk5TdVRLRmk3eTF0dGZwK3NXZDJVd3daSURxSEUy?=
 =?utf-8?B?YjZ6ZGdlODUwQytvVGZjNno3OW8vS25rZTVsSU5NSFVrdkNGUHlhOWl5Q25n?=
 =?utf-8?B?UE1BYW9ZVFlqR1VtWGpialhNU1hhQm5HR0VKYVlHT2FxQzZ0d2RsR3QrWXAy?=
 =?utf-8?B?SXRIS1AzcDhEQk9hOHo5TWxWNU4wSVdDZW5wdDBqNS9nSjBiZHAyc0VvTkVO?=
 =?utf-8?B?T0JqbkVuS3R2MDZxeDdYZmRyRmtIK2NJaHZqQjNDUEhEUVVzTnhEMk90bnE0?=
 =?utf-8?B?S2tacWhZd01UdEgxUVFLMFZ5Y1pxLzlaU1I4NjY4aDR5bGtCNUlkYXFnUG9S?=
 =?utf-8?B?U0c3QkdLd3V6aG1XbXdsMExGUVZzWTN6M1V0TkpPeWhiMnFLS2pGRlB0Tkdo?=
 =?utf-8?B?RGI5YUpnZldSSTEwQ3d5MFlJcGRzUldkaTkyL0x3OFlUaTdxbjZCck9rajRI?=
 =?utf-8?B?QWhvTW8zclpYQXU4S0pGQzQvbHgzYTRXUmNOYTJKUHJQVzJ4SzVmenN0c3dp?=
 =?utf-8?B?eFVEdjQrR2pRSkttQjVQTW5ZTXFtMk44S0FPN1hJQVRXbnFnUlZaUUNMbDN4?=
 =?utf-8?Q?43X+A5TGAGWsEr7Ylzy+pAtJ5M0VA5fQTDYnazf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bbb93a5-f99c-4161-fbe0-08d9042fe0e3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 19:09:53.5425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3IXAQzJBkoiZ3a/hGYmokbLOIeTgjBKbXtNXM+OulywAQVcPmtPqn/iLoVMzdl/mNduKJUOpSVkLoBleRLcMTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4573
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/20/21 4:34 AM, Paolo Bonzini wrote:
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>


Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>

Thanks

> ---
>  Documentation/virt/kvm/amd-memory-encryption.rst | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> index 469a6308765b..34ce2d1fcb89 100644
> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> @@ -148,6 +148,9 @@ measurement. Since the guest owner knows the initial contents of the guest at
>  boot, the measurement can be verified by comparing it to what the guest owner
>  expects.
>  
> +If len is zero on entry, the measurement blob length is written to len and
> +uaddr is unused.
> +
>  Parameters (in): struct  kvm_sev_launch_measure
>  
>  Returns: 0 on success, -negative on error
> @@ -271,6 +274,9 @@ report containing the SHA-256 digest of the guest memory and VMSA passed through
>  commands and signed with the PEK. The digest returned by the command should match the digest
>  used by the guest owner with the KVM_SEV_LAUNCH_MEASURE.
>  
> +If len is zero on entry, the measurement blob length is written to len and
> +uaddr is unused.
> +
>  Parameters (in): struct kvm_sev_attestation
>  
>  Returns: 0 on success, -negative on error
