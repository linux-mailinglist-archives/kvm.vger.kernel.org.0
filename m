Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9618F5B8960
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 15:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiINNoj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 09:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiINNog (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 09:44:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD1965CA
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 06:44:33 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28EDIxiD029321
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 13:44:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=8Jy9l9ygwARtfuhuKdCGJbAudXQeAEtsmYNJsyIRE/0=;
 b=SB5aKj2xGaOuBdL6lTdkZvn2zAMxvelR9EQ1MXs/t+kkkNFe5Bnww4mA4ZxDXsteBtS5
 ih4byOlGzYGcGIHj/rwdAUm+ZAIgJ/G7m3lG4gdgsP949SDdTsy74BcTnAsGp7wkVdAw
 KX9amEb+QyFKh6X0gVnj0p9e9naMucLCU/qKaAmNhrT89xUxwky9c6Pt7Ewi5x+N30bX
 UiGUtUzLvWgLHRrNPsL9Po8Luu8O/1En5sQIESPdPRvsbCE+9ijspcdbs+BbV6JWdFwp
 F48+0igEbmq1DiD8lfxL+4HeZT4JpNbODjb28lO761XEuDWgbzaCKWAdZVwJGH/srioS KQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jkfqys38q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 13:44:33 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28EDKDqg003014
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 13:44:33 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jkfqys37v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Sep 2022 13:44:33 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28EDfI6p012481;
        Wed, 14 Sep 2022 13:44:30 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3jjy2j8tnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Sep 2022 13:44:30 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28EDefBF28639742
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Sep 2022 13:40:41 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 792164C04A;
        Wed, 14 Sep 2022 13:44:27 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3321A4C044;
        Wed, 14 Sep 2022 13:44:27 +0000 (GMT)
Received: from [9.171.23.48] (unknown [9.171.23.48])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 14 Sep 2022 13:44:27 +0000 (GMT)
Message-ID: <f361e962-3fcf-1330-0efe-1d38e89a5d51@linux.ibm.com>
Date:   Wed, 14 Sep 2022 15:44:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [kvm-unit-tests PATCH v3 0/2] s390x: dump support for PV tests
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com
References: <20220909121453.202548-1-nrb@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220909121453.202548-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7AqfhdMfFk2KqA_en9DG0cw6wEeWAkv6
X-Proofpoint-ORIG-GUID: gmKlOzoLViz2_viEvhgVDGnAyPvzjOhD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-14_05,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 mlxlogscore=785 spamscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2208220000
 definitions=main-2209140066
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/9/22 14:14, Nico Boehr wrote:
> v2->v3:
> ---
> - add some comments and newlines (thanks Janosch)
> 
> v1->v2:
> ---
> - add newline after genprotimg_args (thanks Janosch)
> - add a comment explaining what the CCK is (thanks Janosch)
> 
> With the upcoming possibility to dump PV guests under s390x, we should
> be able to dump kvm-unit-tests for debugging, too.
> 
> Add the necessary flags to genprotimg to allow dumping.
> 
> Nico Boehr (2):
>    s390x: factor out common args for genprotimg
>    s390x: create persistent comm-key
> 
>   s390x/Makefile | 30 +++++++++++++++++++++++++-----
>   1 file changed, 25 insertions(+), 5 deletions(-)
> 

Thanks, picked
