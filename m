Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD39310E3A
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 17:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbhBEPLg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 10:11:36 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40954 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbhBEPJG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 10:09:06 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 115EUUVk130128;
        Fri, 5 Feb 2021 14:36:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=bZnsJRLCixV8Q4FHmdZUjiKTh0jq3DZTpRazAIj2Gyg=;
 b=MbkFUBRyJviUHdqnr6hfIzoxP7jpMFCiT+na4RMCg7CCNc4n3V6qZYq2DtFZ1vqvpFev
 w9dm9iBVu9ilYE4rVL5BxBME1K1i4GH2eNzs/S08ekU0UPRBqHb0ujpVf3SCyE3eeN9A
 HNnwp6Aubr6qcYfN2g5iXa1qYApSVaA/FKY81DlivY5qpcoE8PSPpOca4k8+o0tL8hNM
 gon5OXMQVF02QKQbKGlBvKz18iwgGR3gPweScKDvNdPJg9FHDqaaXYcMZPEXje0olhlY
 Sl1BzIeK3bDVFAFFIV+0ixGsMcxHXy5JZ/bCi4scPbMWJCxsw6K+8BAhZKEJXjBgcd/N 9A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 36cxvrcnd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Feb 2021 14:36:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 115ETer1188784;
        Fri, 5 Feb 2021 14:36:53 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2040.outbound.protection.outlook.com [104.47.74.40])
        by aserp3030.oracle.com with ESMTP id 36dh1u0fhx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Feb 2021 14:36:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N5sdtEyVK1erKhf/bl9Die4fmYhQJjMjuywPOz+3YAsOjffrykykSk2KC3DETgJtkDAT9XutUA/GHAB8eBc8wmJeAzY+2m9vyeSjxPoMCaBSGH4nBN6INEK8g1NDh9rhfmC0FNMUs7Q+vsVh1p1CRBvVrp3DeNN7cr3bnEKUaRYUnourtX15xqF0Y+F+UDiUzyx6BhmEJDA4G3jbavZVscYQ0DYjlhp5yRLCiCwVolQlq5iR9PyyaS+gQ+VytGOQpX0qrvUuecuiNQqq1Szu4TUfD2J1WfeImIFSCCeBczKHMBKbMRSjsvSPgrhirBQgW/QaMC7rLR0gkZ6+OdRymg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bZnsJRLCixV8Q4FHmdZUjiKTh0jq3DZTpRazAIj2Gyg=;
 b=QQ9hIqOACdjTPS8yrlcVMbc4kzZnjth8E/aznNUu32s6J6z2IbvZy3EDF3vDfnFdMEK51fPNx1hWhXeTgw/oESY5Q+camNYrxeOpuJXZuukIejWqLKfXCol0WNwg7DZQhUccRVBYw3y5ypxNZXNd2mu7YXRefQKXn6pQrBjtVWiyL9Og4zI4gtkt/FjNdkPeIj8npnA6Aq+w2X0vaPm+W39PIaTXBtX+AWCDmEckXBIO9A+EP8Idtc6g4kBJe9SjOsJ1jnvTbLs+8auSlhBy6ocCiaybcy0AE9zbddBxBNpeZzfP0Ftgsif+9Xk/kbJ2ibL9x7VIwFIVicssY9/y4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bZnsJRLCixV8Q4FHmdZUjiKTh0jq3DZTpRazAIj2Gyg=;
 b=qUekJ+XF+Ygtf3egS76H8sBGp6RZNEl2UtHS7YW2whgWdJWo4PcB+fTh7b6cAe8399Pzl5QEgF6bmEgDo5DfSjvwCGAfEZYzeOiO4qmO6RZYE1CTvaBCqXV2oqXkp41/s1jEWMK4ijKDfv+sMchH++tH7ZiF9IciFlx2np+ucNo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3077.namprd10.prod.outlook.com (2603:10b6:a03:8c::12)
 by BY5PR10MB4369.namprd10.prod.outlook.com (2603:10b6:a03:204::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19; Fri, 5 Feb
 2021 14:36:51 +0000
Received: from BYAPR10MB3077.namprd10.prod.outlook.com
 ([fe80::74a8:8649:e20b:d571]) by BYAPR10MB3077.namprd10.prod.outlook.com
 ([fe80::74a8:8649:e20b:d571%7]) with mapi id 15.20.3805.024; Fri, 5 Feb 2021
 14:36:51 +0000
Subject: Re: linux-next: Signed-off-by missing for commit in the kvm tree
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Woodhouse <dwmw@amazon.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        KVM <kvm@vger.kernel.org>
References: <20210205071821.7cbcb8b8@canb.auug.org.au>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <37cae84d-3ef2-f5fc-0dae-55b3d346ef3b@oracle.com>
Date:   Fri, 5 Feb 2021 14:36:44 +0000
In-Reply-To: <20210205071821.7cbcb8b8@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [94.61.1.144]
X-ClientProxiedBy: LO4P123CA0092.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::7) To BYAPR10MB3077.namprd10.prod.outlook.com
 (2603:10b6:a03:8c::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by LO4P123CA0092.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:191::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Fri, 5 Feb 2021 14:36:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c335adfa-e292-419c-49b2-08d8c9e379f6
X-MS-TrafficTypeDiagnostic: BY5PR10MB4369:
X-Microsoft-Antispam-PRVS: <BY5PR10MB4369213E1AA740F83AE7B189BBB29@BY5PR10MB4369.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9t0ZITnjjaWtg7rIZKigH2dRaAuK8nVdie37KSdD2/4dWtvpkaK8jVAE5PAmqETQExFvUKZxJoeROoSb9OrB/GE4SAVbRFyyrtKGwGBbn7hMnO2Q9F0/i1fm1QNxZN2R8fPFcTd1sGOpt424JSkQOgWcHx639HHyb/o2CHL7xtsivytOP0O0qkzcass8VHWiksQD0/yYCzgo/qlM9yisPahbrrpPrez97YO/Ya+6/r4297JS1PSwanpZ+xleRvJ4//q8uYLLJfSGc3k9Sv+SoUJt4forRdTCfaJ+B/ST/SbLkVG4AZ+P1kyIgSDfEYT4FYJ8Ic8b4NCaqzJ2OIrGcW2DpSf9mcYTsddUP5vjecUNTzqPEaE5AB7xiV7KdHgFlKbVtjBmaudF5wrsprYL31/Ks+KfvnJ0CjqVheUEDZJziLlGBAL9upFkqTey6Vv5AXzf2ynT16YYxnFXEPxnf2A9yMOIY4qamA1rgOwErXcvJCRlzuwPHUGGELEaeAq0zlizyEVz/QqwplVH2v4vkZhWzKyhXBK3q0A7qbbsAtzF9O3l07LXBv7avgbD+DlxTc9ozKob4d1hJWvP6+P8Iw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3077.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(376002)(39860400002)(366004)(6486002)(6916009)(53546011)(2616005)(5660300002)(86362001)(558084003)(31696002)(16576012)(31686004)(26005)(4326008)(956004)(186003)(6666004)(8676002)(16526019)(36756003)(54906003)(478600001)(66946007)(66476007)(8936002)(66556008)(2906002)(316002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?K0wF9IB1+KyM7qhUosEzZPtpEAGAZRRJEmVBnt9Wf6Y1IRLzFJ5+DeYG?=
 =?Windows-1252?Q?XIuNL7ZGbJBt4le1cSkGw1DKafx95chtBlGvmFLzl/qPaGgLiGE1w1r5?=
 =?Windows-1252?Q?34KDuPxtTN1exgm0+PZFq5HnKDhs9iTJAh0ZECoXqPdNzIyu/O5XMJnH?=
 =?Windows-1252?Q?tp8FP19kqw+jOD4IRy600rU2qA+9j8sPigk+GJBy6nITkEanI2JY8tJV?=
 =?Windows-1252?Q?AhhOGT7IEmaIjO4Z1PmWuJpMDgp0/5YD6IAFsN3kjAsGhnCKnU/0rMTt?=
 =?Windows-1252?Q?0POEeGtIRmcBqKCDN6a1vj8YhwWy0xTF1Lr+hFqOPy4X9X/6oFhn95za?=
 =?Windows-1252?Q?4TiS4nghY7q8SbsbcFgTzv9wEDah9JD0fTp2zwjzjqN83S1cL7WOAb3T?=
 =?Windows-1252?Q?OkHeFQ5azu1LVj1zfQcD64IontXX4aqMKG+Uxc6OZS2Hi8YUxnhfFUJH?=
 =?Windows-1252?Q?4VToKLJaZGRa85hxYc32auDkneO90Jm5SweI+ecNObIzt29x/y9wTWlP?=
 =?Windows-1252?Q?98VrA9r5COhz01PSOq4L53Baf2QHkc3iDGNcvxEf510q2MXaR+cjCnl9?=
 =?Windows-1252?Q?8Qilcl2DsYZ7KWPy5gJiFbHUo0Jv3qf3A3BV8hTZJ1Ilj/JyWj2YkNIz?=
 =?Windows-1252?Q?PICEnONguiT0xSEv80HuGvU7i8aFtdqR5G3ZckbiNayC9cK9KNEkjSAX?=
 =?Windows-1252?Q?lytPM4jTgzpwRmZQ6wi9B+J5Pn7k3yQ8eMAkfbhUCs3BlF/OQ5KwPupo?=
 =?Windows-1252?Q?FNcy1nYIpSC81SQ8zwdQI50ZmIO/S6EB7jNabAmvb1sRItuW10C23XxE?=
 =?Windows-1252?Q?s7o7JV50ffeMn39ozT5W1r9NgDK+JhbU2ZC4+Q8383dM8Pb96tBg55K8?=
 =?Windows-1252?Q?Y/1uCEjxcuMfN2gfmm+dnV7KnRn7ssX4wn6GtdtyT/YhPr0t9l7tILVS?=
 =?Windows-1252?Q?Aaa2KuC+ChPVXBK4+oj1zsK9hWgeiGW6a8fz72NaqSuf6qhxW7/U99W9?=
 =?Windows-1252?Q?BKvnOdTJuUtClbgFqfZf+NLn9ufcatejgj/ixlWm0sD/YytE9b7ExN44?=
 =?Windows-1252?Q?Fui5ZXtENWjRFRZ3Hr/LN/3lrqD1EYjmELh5ZBdQr7PYTl7HSZYdl88q?=
 =?Windows-1252?Q?rwLfIWj8ILZZbgag5rRsaJ9Mc9wFgsXU802CuJhLqIBx/CcCDnWS9ph5?=
 =?Windows-1252?Q?rX4pcckWHRAlEq7UpCE66W4yebAgYQTe62LJv3BMdfylvmQ5L5mAfmFW?=
 =?Windows-1252?Q?TDYAyvDCieBHNhpsIultz5/gvev4JxCAZgdeT2xg76DzqGfJtiRxXwCH?=
 =?Windows-1252?Q?g4KzIlOnphBMmU6CfzRzpBmCS/P5N7JQnu7jLXdKTDUTOMVJH5sU3arH?=
 =?Windows-1252?Q?GgygskTcmqPz9RLEgRjlmAK9bHf0Sv2RYIdacHHADjOdVefnvZg5ECEo?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c335adfa-e292-419c-49b2-08d8c9e379f6
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3077.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 14:36:51.7176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ak6qh47xVqQMe3Jvui9y8Sl1woVi8GrC60v6hLSm7OgXKdsBpZA5bOvrirZrF6IVRGk3+uqkCGolo66nefhGnAThjdojNPqY2dZbIwSM1+A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4369
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9885 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102050096
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9885 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1011
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102050096
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/4/21 8:18 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Commit
> 
>   79033bebf6fa ("KVM: x86/xen: Fix coexistence of Xen and Hyper-V hypercalls")
> 
> is missing a Signed-off-by from its author.
> 
Except that David is the author of this particular patch, not me.

	Joao
