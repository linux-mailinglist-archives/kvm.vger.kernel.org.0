Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 543B72901D2
	for <lists+kvm@lfdr.de>; Fri, 16 Oct 2020 11:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405116AbgJPJ1H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Oct 2020 05:27:07 -0400
Received: from mail-eopbgr60084.outbound.protection.outlook.com ([40.107.6.84]:29595
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2395065AbgJPJ1H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Oct 2020 05:27:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fGOgt/3yXyEaJxlwGR/8KLEPnaKAahYHoVHHjvSj28kbaf8Sd8lKZ9kdf4yJ/iTz7tzgONZVq2DYiT1z4IJJ9dFnrXPyEcPNHDdR3IrH//XSrws0fAJp8nnH2SyyCKw9f2FFrsytQvgZMTUyYkOYDpmXQkIpoM/YsR7369rgjzfz5miYYHsCoQOa9/QQrE2X6JUygKn8f47TRsF3/AsBiDw70NlB1//Q1T1VUMHGFeRKtuXB6RDZFpgVWQIveJAnz4SHwmhe3zkMu4yVD6b9mDum8hSMhOhaUuc8zQFHqaR5tfJrQHFrSHVOEZU1vR4VvG4nVnXxny2xuAHsdB+NAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5WXxGMWfzdGX8GWWIRXUqQBgQnZjM5Z7GNJYs5QsMw=;
 b=ZU2TAPZzutNVtGC8DagWScDhN0LQBPZL/mify+Cg8lCutEhVf17z9GLjH3CxWq4ncc5/uSe8KsClOw/Es2pKhJDSLjE/08TYpuJ9y22ZRpvmQnS95Uc36XUwdbY4O8YWqCzncijc0KSSLp0pY8jem/PYf9zvdAuZQk5k4Me+wVNuWRK2FRbeg2pluCqUzPFWotNAkKVLmt9qjGXamJBvtXtAJalewkTGvJR/ZT1Pt1INureyJiCXM6KZ1++NCgNkHlIQ7Qp+rgSvb7JlTrJRpMnQuqK0e9G2dBFcogNV8zwR+xZNj6KzW8KnnYaWWmvG/p6BYG5/NFxTyMJhSiSygQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5WXxGMWfzdGX8GWWIRXUqQBgQnZjM5Z7GNJYs5QsMw=;
 b=IjUekSPfBGJqoDkIGzRSlhyHHgSOCLCyRb4cvZUT8Jd+61mGxLxSqXb3c1wBOqrycdH7c28fZDoXsR5mwPLsl89d2fjiMAMk9UQ/jVkY4AKDi3Vdxt8T8TtHsHnnfMfVVxtV/72BNA5i/90rdUTPt/iBEUj6oR+Al0bfr9KhrY8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16) by VI1PR0402MB3583.eurprd04.prod.outlook.com
 (2603:10a6:803:e::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.25; Fri, 16 Oct
 2020 09:27:03 +0000
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::6cf3:a10a:8242:602f]) by VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::6cf3:a10a:8242:602f%11]) with mapi id 15.20.3455.032; Fri, 16 Oct
 2020 09:27:03 +0000
Subject: Re: [PATCH] vfio/fsl-mc: fix the return of the uninitialized variable
 ret
To:     Alex Williamson <alex.williamson@redhat.com>,
        Colin King <colin.king@canonical.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201015122226.485911-1-colin.king@canonical.com>
 <20201015125211.3ff46dc1@w520.home>
From:   Diana Craciun OSS <diana.craciun@oss.nxp.com>
Message-ID: <65c7ffdb-fa92-102d-d7d1-29bb7d39fcb7@oss.nxp.com>
Date:   Fri, 16 Oct 2020 12:26:52 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
In-Reply-To: <20201015125211.3ff46dc1@w520.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.27.189.94]
X-ClientProxiedBy: AM3PR05CA0149.eurprd05.prod.outlook.com
 (2603:10a6:207:3::27) To VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.122] (188.27.189.94) by AM3PR05CA0149.eurprd05.prod.outlook.com (2603:10a6:207:3::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Fri, 16 Oct 2020 09:27:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c212ac43-92f6-4ee4-3335-08d871b5a3b2
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3583:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB35834F817E0E9CE33F72592EBE030@VI1PR0402MB3583.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o8LsS5EP8rgLa7sj6rpb+C2HNsA6ZRHXREey+UxXw0puH/9m1IC32GP2SK5hHBjoQdMihaMKejhtuCCCqfDwfRW/mopK0huQrodjDn7apKuoRLFxW6f+sMV8myZ99EhSSXDpWzMvYoNmxMDqhXQYrFbDiTSjIumEoJ1UL9QD/yPjTPrmWTTCMbFZHv36F2T8n+VM97g+S7Tq4GhyBCKQ9UYcWhc7geVAjqZKRSsEtlWVoN5UmdgvtJgprhYwgPOteYLlLfVmHUE4cgYD4nANKzQt63wOmWvZrPLaxTsyrKwKj8uFC6CUVSck3s5qcmQjh7EHmli6zC9eNzM2BZq+6tkXlBzRS9C8WJAmwv4v3yUl9Qde+7Ml9qLT7VFcJLHEYjM2a7uhiflMTZNT0MGAyQ0lvf3itoZgsMNmXctl9xA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB2815.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(366004)(346002)(31686004)(52116002)(478600001)(6666004)(34490700002)(53546011)(83380400001)(8936002)(2906002)(86362001)(8676002)(2616005)(956004)(4326008)(5660300002)(316002)(110136005)(6486002)(54906003)(66476007)(66556008)(186003)(66946007)(16526019)(16576012)(31696002)(26005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 3mKLoDK3+UG5lOiBueH/cBq0N/NbKzQykocEci32iTRNkK/RPrkJzdhTTUfWveIEDxlXAj6UCbdGcMZmzG7zl4p/R8FLQpB4cAHYHP0SU6ovdo0XP9t1pMFusmYiDGM8ufX3/VGmRNW0h2B+tb9a08MiKz/7VcF8IX/2V79EZNAq4ugUqA+8wpjapsArLvmINWO14DTKMXvDdVMZW57sqlO2qPha3fubGVRGtuYPWyO+oyWcrxQJbxztc9ANQTc6YnwRwoRu6qaL9mD4LLShf/SWxTJacEhQmh0uOunNmMIpCYr7lZoOMbC+CNllaHKedw6+IVRj7ywkSWIUSi8Dyc1B3JrG5NoqxWMKZKi5OeAXXzHhw72WAvwwnhKC9il5s7cwPLu6MnmEiik8/MOaWmtH9h31JtlFxEIHI5vQacRUWwXg2nnfNjh9+ObJ8paZyLtI7jkDyoZhMwWuhXPBAYoqwwUhGwo5QXlihTxqkCwOfhJ/WyecWQlf0c2Y4uiJjFnp+q5Or+lTsvj0/cF4i/Q7oIzNi0VLWp+dNYpqTcE5BWGcAT1ozZa63Vjs65c1YKxXHi+zf5rL3HJrmoVjJzCu22nFf3C55w4zCEoB5GBcNzeJPeuVljzU2ulmU5HphqD9jINL4K+VBQabYBJRVQ==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c212ac43-92f6-4ee4-3335-08d871b5a3b2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB2815.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2020 09:27:02.9515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KSbHUemUSSFcMIjcDwrEGXLt9oNzCKaVl0JGjVrGHrQ+vw3FLyHb6MWxdnogm0lm3MqyF4jPcXF8AFVhLToACg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3583
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/15/2020 9:52 PM, Alex Williamson wrote:
> On Thu, 15 Oct 2020 13:22:26 +0100
> Colin King <colin.king@canonical.com> wrote:
> 
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> Currently the success path in function vfio_fsl_mc_reflck_attach is
>> returning an uninitialized value in variable ret. Fix this by setting
>> this to zero to indicate success.
>>
>> Addresses-Coverity: ("Uninitialized scalar variable")
>> Fixes: f2ba7e8c947b ("vfio/fsl-mc: Added lock support in preparation for interrupt handling")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>   drivers/vfio/fsl-mc/vfio_fsl_mc.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> index 80fc7f4ed343..42a5decb78d1 100644
>> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> @@ -84,6 +84,7 @@ static int vfio_fsl_mc_reflck_attach(struct vfio_fsl_mc_device *vdev)
>>   		vfio_fsl_mc_reflck_get(cont_vdev->reflck);
>>   		vdev->reflck = cont_vdev->reflck;
>>   		vfio_device_put(device);
>> +		ret = 0;
>>   	}
>>   
>>   unlock:
> 
> Looks correct to me, unless Diana would rather set the initial value to
> zero instead.  Thanks,
> 
> Alex
> 


I prefer to initialize the variable to 0 when it's defined. I'll send a 
patch for it.

Thanks,
Diana
