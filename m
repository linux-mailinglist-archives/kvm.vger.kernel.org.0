Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D7A4B55CE
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 17:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbiBNQMQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 11:12:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbiBNQMO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 11:12:14 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964ABC20
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 08:12:06 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21EE9kNv024281
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 16:12:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=UcCgQte+EOIVtmhEv1P2GNJ9OmoQVPKLPT8rEqLn7s8=;
 b=bhxW7HzLYSQKM8Buls0gfNZ5U8Hwd4i7oxMRznEf0E/QZkyI/3weeu/OjVNLIsSkmALA
 XXCfdzCzhmKaH8ngwD5d4ux4fwMVEjs8clAh3nU33NPTe2ANj/D+e0ykUOAus+ZyEZ9z
 rGhJJcgGWLMhxfpuU4Xc/W6kG8kfYlpMkoMdBPX53UMlLGgT4tnY1pUT+ZjR2b+Y1UGZ
 NguUSCK962evEuWClz9eS/VI0mz74h5kUhqoywk7//griTJsw8mKm2Q4NUGSNy7Ui2ah
 a6DWOtHgpEyTgzRYiacjwuiy/Cic9GngqQ+PPSwWIQy1CNSgGIYznhB743fsHUByCV9h Ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e6ycqx0an-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 16:12:05 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21EFvTK2011836
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 16:12:04 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e6ycqx099-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 16:12:04 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21EFvofj005823;
        Mon, 14 Feb 2022 16:12:02 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3e64h9670n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 16:12:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21EG1e7546334354
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 16:01:40 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D582F4C04A;
        Mon, 14 Feb 2022 16:11:58 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86CD24C058;
        Mon, 14 Feb 2022 16:11:58 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.29.228])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 14 Feb 2022 16:11:58 +0000 (GMT)
Message-ID: <54e734291b7b824e68cfdf3183bfd7cf2d6c7779.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 6/6] s390x: uv-host: use CPU indexes
 instead of addresses
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        scgl@linux.ibm.com, seiden@linux.ibm.com
Date:   Mon, 14 Feb 2022 17:11:58 +0100
In-Reply-To: <20220204130855.39520-7-imbrenda@linux.ibm.com>
References: <20220204130855.39520-1-imbrenda@linux.ibm.com>
         <20220204130855.39520-7-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: d2xLDmVErO3u2vFKq4tG3HjwFXRSqJ_K
X-Proofpoint-GUID: roqh2Vln32zVMREHtZa7Y6sBmHEmWo4v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0
 impostorscore=0 malwarescore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202140094
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-02-04 at 14:08 +0100, Claudio Imbrenda wrote:
> Adapt the test to the new semantics of the smp_* functions, and use
> CPU
> indexes instead of addresses.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  s390x/uv-host.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
> index 92a41069..a3d45d63 100644
> --- a/s390x/uv-host.c
> +++ b/s390x/uv-host.c
> @@ -267,12 +267,12 @@ static void test_config_create(void)
>         uvcb_cgc.conf_base_stor_origin = tmp;
>  
>         if (smp_query_num_cpus() == 1) {
> -               sigp_retry(1, SIGP_SET_PREFIX,
> +               smp_sigp_retry(1, SIGP_SET_PREFIX,

As smp_query_num_cpus() == 1, smp_sigp* will always run into an
assert() here.
