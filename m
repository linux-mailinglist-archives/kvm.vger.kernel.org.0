Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0081AD42D
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 03:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbgDQBgF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 21:36:05 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44288 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727854AbgDQBgE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 21:36:04 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03H1SX9h036154;
        Fri, 17 Apr 2020 01:36:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=8ExsW9WPMHwTE4nxzzvDu2N5qKh0S3fAcynljMNDMAI=;
 b=xY+WrsPPLJ7V/TmWEQBf+MCk/H9sXvu2qP1UiDd+D+hcBS3DEQVjxJPb6HNDR1vnFiBX
 a12p//OcGt5/VRmRoUTUreiXNGRKWKa6evsoJ4s04JifXQ0jd1506mJyw8qs8cJaRpG0
 PSrpwOXamQ9yKBicWkMqSTEtOGj9P8lWKGGKURZZVYuBUHZ4VHHb4SLOjnbSw001w+8l
 CIKSxbzSgw8an40W5wOlNVieDCyq5YJasqjvSsErEJwxHoq62wjZ+sF0oSQ3Ih4LU96f
 WFP4Pkc0jSrXjjzmjrMRhrUtVga2up7KJAIaDHKCNGLN4L5iqVt7Zb6bl/XgNP21xC4N /w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30dn95vmar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 01:36:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03H1W9xR037603;
        Fri, 17 Apr 2020 01:36:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30dn9hbsc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 01:36:00 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03H1ZxRw008126;
        Fri, 17 Apr 2020 01:35:59 GMT
Received: from localhost.localdomain (/10.159.142.247)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Apr 2020 18:35:59 -0700
Subject: Re: [kvm-unit-tests PATCH] nVMX: Add testcase to cover VMWRITE to
 nonexistent CR3-target values
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20200416162814.32065-1-sean.j.christopherson@intel.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <d0423845-db40-b9ce-62b7-63bc36006a28@oracle.com>
Date:   Thu, 16 Apr 2020 18:35:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200416162814.32065-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9593 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004170010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9593 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 mlxscore=0 phishscore=0 spamscore=0 impostorscore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170009
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/16/20 9:28 AM, Sean Christopherson wrote:
> Enhance test_cr3_targets() to verify that attempting to write CR3-target
> value fields beyond the reported number of supported targets fails.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>   x86/vmx_tests.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 1f97fe3..f5c72e6 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -3570,6 +3570,10 @@ static void test_cr3_targets(void)
>   	for (i = 0; i <= supported_targets + 1; i++)
>   		try_cr3_target_count(i, supported_targets);
>   	vmcs_write(CR3_TARGET_COUNT, cr3_targets);
> +
> +	/* VMWRITE to nonexistent target fields should fail. */
> +	for (i = supported_targets; i < 256; i++)
> +		TEST_ASSERT(vmcs_write(CR3_TARGET_0 + i*2, 0));
>   }
>   
>   /*
We don't need VMREAD testing ?
