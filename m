Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 123584C17B0
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 16:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242468AbiBWPtd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 10:49:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242458AbiBWPta (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 10:49:30 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1E2B82EE;
        Wed, 23 Feb 2022 07:49:02 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21NFDFpj029752;
        Wed, 23 Feb 2022 15:49:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=fqs4ajVPfMszPVnIcH172ne7Ko45oGQI0DBTFEGdxRE=;
 b=A9e2LKh7S4ZkWrUr2lJU20fkgbyzgi4R5j4EMdbLrehdtCegn5UFa5mv8rBfLDbVD3Y9
 K7jVppFPIpuj1fGt8amzI4HyiB5CwAaMd0kqSjg+qouoAE3PCwNihu/HEl2ulLps0V7C
 QRYFZxtJ6ssM4nuaKyWM0UXb6npjFJm6TG0DnxtbEYPddXrj1abPcx2jkH4wVth/+Urt
 C4nL1kN4YxX2oeQ2DmKj2aXkNRuEeh9a9tBWK8y8mA3mzx382g0nx3bv79LTkl2PlHd0
 AP4R8Rw9ubpc4LvdADdappfSsa27mNUBilwV32iZvVBuIPhgbAa4S6H4Oamjyf5HCBOS 3A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edqc90xch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 15:49:02 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21NFENaR006898;
        Wed, 23 Feb 2022 15:49:01 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edqc90xbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 15:49:01 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21NFhjYC003875;
        Wed, 23 Feb 2022 15:48:59 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3ear69b8d4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 15:48:59 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21NFmubJ48365864
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 15:48:56 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFE1511C06C;
        Wed, 23 Feb 2022 15:48:55 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8CA1511C05E;
        Wed, 23 Feb 2022 15:48:55 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.2.54])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Feb 2022 15:48:55 +0000 (GMT)
Date:   Wed, 23 Feb 2022 16:36:12 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Steffen Eiden <seiden@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 4/5] s390x: uv-guest: add share bit
 test
Message-ID: <20220223163612.598bc966@p-imbrenda>
In-Reply-To: <20220222145456.9956-5-seiden@linux.ibm.com>
References: <20220222145456.9956-1-seiden@linux.ibm.com>
        <20220222145456.9956-5-seiden@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mOJ22Q_8P6CStMmmdLB05IKNt0D8EJq1
X-Proofpoint-GUID: AxyV_opFKDmS6lCwA6gJ1xcT1ToA7lNN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-23_07,2022-02-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202230087
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Feb 2022 14:54:55 +0000
Steffen Eiden <seiden@linux.ibm.com> wrote:

> The UV facility bits shared/unshared must both be set or none.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/uv-guest.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
> index 728c60aa..77057bd2 100644
> --- a/s390x/uv-guest.c
> +++ b/s390x/uv-guest.c
> @@ -159,6 +159,14 @@ static void test_invalid(void)
>  	report_prefix_pop();
>  }
>  
> +static void test_share_bits(void)
> +{
> +	bool unshare = uv_query_test_call(BIT_UVC_CMD_REMOVE_SHARED_ACCESS);
> +	bool share = uv_query_test_call(BIT_UVC_CMD_SET_SHARED_ACCESS);
> +
> +	report(!(share ^ unshare), "share bits");
> +}
> +
>  int main(void)
>  {
>  	bool has_uvc = test_facility(158);
> @@ -169,6 +177,12 @@ int main(void)
>  		goto done;
>  	}
>  
> +	/*
> +	 * Needs to be done before the guest-fence,
> +	 * as the fence tests if both shared bits are present
> +	 */
> +	test_share_bits();
> +
>  	if (!uv_os_is_guest()) {
>  		report_skip("Not a protected guest");
>  		goto done;

