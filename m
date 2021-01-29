Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245D8308BDE
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 18:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbhA2Ro4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 12:44:56 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40780 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbhA2Rmo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 12:42:44 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10THe02P099546;
        Fri, 29 Jan 2021 17:41:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=Wb+lnS2CyugkrVmMH19jKwQZBNR2xB3RGfDCL+1CBQI=;
 b=KeyblIXiipcYU9qr/ifao7+WG0Haz2qoPrZ+O1PysOyl9Y3vUp42Dq12L1TTRY0Jvd07
 YqAFzk2hxebj24UPlH67dsBoRPayHFhK9R/SQJ1uo13dcLGmMWvODaBvTdHk68jS+/vk
 xx+7kUQZRut0TKUCoxbsx9TU6zAZ1bvFlk/1fKZxE3JVuY90elJmoouJku7onxv0Hj3C
 tbeDHWzzeEqbGBABnhSV6V5hsp3ci2XzqexXJPCHgowvZyanbKeCUJPLWnv28S3ju9E3
 d6xu3vlgkM7GIzGo9CX7p/gdkYfnjRXLXTkFvJXVwzfUiAatQJZH7fcZOuaJPh6nhmCI jw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 368b7raht8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 17:41:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10THZwYI158996;
        Fri, 29 Jan 2021 17:41:41 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by userp3020.oracle.com with ESMTP id 36ceugyj8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 17:41:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QSPWWssQqRAGsVOIqfqY2V6kRARihbXGdFNwAQ3fehBzejXfiRDe9BmAuUWybSbsk0vGOOqqGDwa7d9EzKV5F4ZE0Qti16DlQNm5mRzKfWZ81MqirlMtTkVGotWIkUpLtsW7OoLtFW5/Eq9tpf++CemBLt1aKeCIdRACXnEnvljNAgnlKdnY9QoNe/catMxX3OaxteJbUbDWhczbkrWyaUrBaDjVqLaFiongeOR0rmwNEpLHQlvAUK3wQDHZo+ySBsf5cVgMQMbqdfOHdAoxpMI/bJdhAIRP1Vg4I1sWM9vwdfrZs9DOsQcaczPFOOvgHf5+vLw/g8sROPDhtVnsvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wb+lnS2CyugkrVmMH19jKwQZBNR2xB3RGfDCL+1CBQI=;
 b=RXpjC/jxgtVxTAwKmyyhfG6P5jlYMQ33diQDNGUPDSNNAEWjZCIrChlw9zjqVMn2HyyRpRyGPhLychrcxOtOjVvP+qBul8z/3fCJ+yT9frDVoY5ZbgiCZLR1G+9frSNPwJHDllI/MXXmU81r1jGWslEpwwOlIsAjKurgRLDLkDxRKTvdGoEqQ68dLDlB6DAXXhRKqCDZsSAY1G4a+9UlzWYBEwtio3ZalglEO/Kh4mCUkEE0jEiRbrWoMicY8ltNQOIFmQsMS9xVnrBSUA3G/iTgGwoZwKXhEQxPQwzwpQmk+wTKLbdfDIymn4zC8K4xKCaTNQx6TTU3m0EVEvVYwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wb+lnS2CyugkrVmMH19jKwQZBNR2xB3RGfDCL+1CBQI=;
 b=eklBBBpujYFr+yYEdVWMuaOzYsx9g5OPgYTLVcP9YE0cNdRtcqZMzgQtXClM96KLD+2iZQliDpEUEALhgc6w5HxqnrRGSeZfmEghQrRJLxZlzNkkvj954QFchznn3f5OijvMCToWq9+zoUFx6akSg0o6WIjlSZ8vuj6uMpN3Dsw=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB2044.namprd10.prod.outlook.com (2603:10b6:3:110::17)
 by DM6PR10MB3018.namprd10.prod.outlook.com (2603:10b6:5:6d::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Fri, 29 Jan
 2021 17:41:39 +0000
Received: from DM5PR10MB2044.namprd10.prod.outlook.com
 ([fe80::3c1b:996a:6c0f:5bbe]) by DM5PR10MB2044.namprd10.prod.outlook.com
 ([fe80::3c1b:996a:6c0f:5bbe%6]) with mapi id 15.20.3805.019; Fri, 29 Jan 2021
 17:41:39 +0000
Date:   Fri, 29 Jan 2021 11:41:35 -0600
From:   Venu Busireddy <venu.busireddy@oracle.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH v6 2/6] sev/i386: Require in-kernel irqchip support for
 SEV-ES guests
Message-ID: <20210129174135.GB231819@dt>
References: <cover.1611682609.git.thomas.lendacky@amd.com>
 <e9aec5941e613456f0757f5a73869cdc5deea105.1611682609.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9aec5941e613456f0757f5a73869cdc5deea105.1611682609.git.thomas.lendacky@amd.com>
X-Originating-IP: [209.17.40.36]
X-ClientProxiedBy: CH2PR02CA0022.namprd02.prod.outlook.com
 (2603:10b6:610:4e::32) To DM5PR10MB2044.namprd10.prod.outlook.com
 (2603:10b6:3:110::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dt (209.17.40.36) by CH2PR02CA0022.namprd02.prod.outlook.com (2603:10b6:610:4e::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Fri, 29 Jan 2021 17:41:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55e0d83c-94b2-40ea-ba19-08d8c47d21c5
X-MS-TrafficTypeDiagnostic: DM6PR10MB3018:
X-Microsoft-Antispam-PRVS: <DM6PR10MB3018E0AE2A5C0ADC12BF3412E6B99@DM6PR10MB3018.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:989;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RirXzh2FAm6Qy6DQy1DxcHcp8MWuNHp0xEapwVraJwgJ1twRsQryBEMaZjPLnsyKQdJft45BDPISW2B6KnayeRO+sZyIscpY4TmkFpkS90cPTyQNnplcVQ+4Au1xhHVUaj5sVxNmK9jmBX8WVS5xtRPDe0mzcNOwO8ccfmBK9CihCDj2GC7wodzLR4PNu9dR76Dq94wOxnVpRCtPI/HcnnczIkuHEW5GRGbhhuRbCrlbjUgr3OoFqc5nRJcL7l/29V/8VkidrnkL9N5ajHzQzt8nm9IbNM30C4QzHPZGV19y7p24ns+oTVTOuaOu/wPTEmDjxjfKTq0yMz6L+KBv5WoKkUTmPGmzk6/dduZ2HHUeInqFwpSSoXNc1kmpynIhEtgF0c1wAOK1YUX6jC2HpA/sbr4BKnz8ZjHAY+zMTZDWoMX03whAKZc8jD8TKLxn3AO3cMYHWUB6EHYN9MRR3M7UOLJwvaszHk7zSAFwygY7tB/U9Bqy7s5siIRrXD+GD04lCfuSb2mWLAFzpPoKcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB2044.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(346002)(136003)(376002)(33656002)(55016002)(186003)(9576002)(16526019)(7416002)(8936002)(86362001)(9686003)(2906002)(1076003)(54906003)(6916009)(6496006)(4326008)(5660300002)(52116002)(66946007)(44832011)(66556008)(956004)(53546011)(26005)(8676002)(478600001)(33716001)(316002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?OP0B8ECjYAcR0RsMc98RfbW4Lm73dZSFNIF1ZClr4eH/DXdwkfCjB1WHNhp8?=
 =?us-ascii?Q?TramrIzWGPpakYE9AZRpdvv+o7oR5rV/edzSLeAJ/cHTwR9mgwZPUvQP/XMM?=
 =?us-ascii?Q?2XAvAjv/CJyqy72qo9N51hOUGQW5x7dgZPLLXyruKLPZIJjgdswSMK74lZIG?=
 =?us-ascii?Q?wYfhJVUbr225oR9R8oPUodvFS37ohEEsaE1w6/wwb375tA5sw2xkWrTqrdnJ?=
 =?us-ascii?Q?GnzMd/JuDNU3RvDROuC2fLgXYQ3iIyghe4LqJlZ3qx8q4Y3s6gDATK5r+N3b?=
 =?us-ascii?Q?K5RMFT8FKjT4ytHikcbdAW6tVRSsUrKlkbupVOgEJE+iPfBYjulqAg8RXiq2?=
 =?us-ascii?Q?ks6Xo5SnlML5KVXVsq5blb0dpSFpA9kodeO7m//+JbIjW/FVLhA7T6CX4g4a?=
 =?us-ascii?Q?TjYHDOasiadeNYLi8+HDystwSWvkczfSv2TBMHMT+Oth17ThRDP7keFPeHsd?=
 =?us-ascii?Q?oOLmmBBF+ORL1dG+EGSCGZYvWWTrXajwxFjjfnBtMvHzxuAcpcyStu2oJYfH?=
 =?us-ascii?Q?aSkMZLZz8LwaCLrKvqJlXGFq+ciISuKxRQzzEKHfk1XBXV8ENHFABXPwi+3c?=
 =?us-ascii?Q?/TGqbuOcGI+pPXrZ3dMCBL3IL6mcJJpAD5+radnrc8njZsACGFdbEvLL0SmX?=
 =?us-ascii?Q?7/OStFhUtC29Gwy5OzRGqxv7z8yEtmihY/7DtsEnD1eXG4AWlvAAe76Rc2kI?=
 =?us-ascii?Q?DGFYZWvK4apKSgeJdZbSYBsHhuDO2ymRfdVN+p5Ety2SFTRsUFSzafZgubnr?=
 =?us-ascii?Q?JqOU8vBtzKrMEyzSKdpu/WEcwIHf9C58+dCsJkLWX7PSesun3AVNGTWObd6p?=
 =?us-ascii?Q?0P6hYbc6u8Ushz/rsOtPbbiqOd10y7abzwWUHVijq8oIhuLHd6Nvx11oIB0o?=
 =?us-ascii?Q?J2eo6yGiQPHtFLO8UHvLxknVOo4pOhcwT9BL+5Epgura7h/US8UBO8+TDk1O?=
 =?us-ascii?Q?ITdimsT7Wfxnvjd/I/5RRvMB8LriTum48VeWbbFOTzhiYMSAK7wuoT3M0Dro?=
 =?us-ascii?Q?7d5QY7Y1QYNrHzB/U9JCf17gYJewBTtSQm9mE/xqyhTyAXoBTBVz01uS6Yoa?=
 =?us-ascii?Q?YEB0h91q?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55e0d83c-94b2-40ea-ba19-08d8c47d21c5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB2044.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 17:41:39.0996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FGvQ7gz/acc2kyNSOCJ0DGypEp4oR5W2wSlKcmresj6CkRBbZecCROEArpuz1+CMTvCmFwK2S+O2V9aG6/zX5nL7Olm0LBAKnNjmsl/y3Gs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3018
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101290086
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290086
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-01-26 11:36:45 -0600, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> In prep for AP booting, require the use of in-kernel irqchip support. This
> lessens the Qemu support burden required to boot APs.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Richard Henderson <richard.henderson@linaro.org>
> Cc: Eduardo Habkost <ehabkost@redhat.com>
> Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>

> ---
>  target/i386/sev.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index fce2128c07..ddec7ebaa7 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -776,6 +776,12 @@ sev_guest_init(const char *id)
>      sev->api_minor = status.api_minor;
>  
>      if (sev_es_enabled()) {
> +        if (!kvm_kernel_irqchip_allowed()) {
> +            error_report("%s: SEV-ES guests require in-kernel irqchip support",
> +                         __func__);
> +            goto err;
> +        }
> +
>          if (!(status.flags & SEV_STATUS_FLAGS_CONFIG_ES)) {
>              error_report("%s: guest policy requires SEV-ES, but "
>                           "host SEV-ES support unavailable",
> -- 
> 2.30.0
> 
